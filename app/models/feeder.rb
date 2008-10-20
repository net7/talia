class Feeder

  def feed_contribution(contribution_uri)
    require 'net/http'
    xml = create_contribution_xml(contribution_uri)
    #TODO move URL and login/pass in some configuration file
    exist_servlet_url = URI.parse("http://gandalf.aksis.uib.no:8080/nietzsche/FeedExist/store")
    exist_login = 'oystein'
    exist_password = 'arm14erf'
    params = {'xml' => xml}
    req = Net::HTTP::Post.new(exist_servlet_url.path)
    req.basic_auth exist_login, exist_password
    req.set_form_data(params)
    res = Net::HTTP.new(exist_servlet_url.host, exist_servlet_url.port).start {|http| http.request(req) }
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      res.body
    else
      res.error!
    end
  end
  
  def create_contribution_xml(contribution_uri)
    require "rexml/document"  
  
    doc = REXML::Document.new
    doc << REXML::XMLDecl.new
    root = REXML::Element.new("talia:source")
    #FIXME: must the namespace e set in some constant ?
    root.add_namespace("talia", "http://trac.talia.discovery-project.eu/wiki/Exist#")
    doc.add_element(root)

    contribution = TaliaCore::Source.find(contribution_uri)
    metadata = root.add_element(REXML::Element.new("talia:metadata"))
    metadata.add_element(REXML::Element.new("talia:maintype").add_text("contribution"))

    type_query = Query.new(TaliaCore::Source).select(:t).distinct
    type_query.where(contribution, N::RDF.type, :t)
    type_query.where(:t, N::RDFS.subClassOf, N::HYPER.Contribution)
    type = type_query.execute[0].uri.local_name

    type = contribution.class.to_s.split('::')[-1]
    
    metadata.add_element(REXML::Element.new("talia:type").add_text(type))
      
    subtype_query = Query.new(TaliaCore::Source).select(:t).distinct
    subtype_query.where(contribution, N::RDF.type, :t)
    subtype_query.where(:t, N::RDFS.subClassOf, N::HYPER.ContributionContentType)
    subtype = subtype_query.execute[0]
      
    metadata.add_element(REXML::Element.new("talia:subtype").add_text(subtype.uri.local_name))  
    metadata.add_element(REXML::Element.new("talia:uri").add_text(contribution.uri.to_s))

    authors_query = Query.new(TaliaCore::Source).select(:n, :s, :a).distinct
    authors_query.where(contribution, N::DCNS.creator, :a)
    authors_query.where(:a, N::HYPER.author_name, :n)
    authors_query.where(:a, N::HYPER.author_surname, :s)
  
    authors_data = authors_query.execute
      
    authors = metadata.add_element(REXML::Element.new("talia:authors"))
    authors_data.each do |data|
      author = authors.add_element(REXML::Element.new("talia:author"))
      author.add_element(REXML::Element.new("talia:firstname").add_text(data[0]))
      author.add_element(REXML::Element.new("talia:lastname").add_text(data[1]))
      author.add_element(REXML::Element.new("talia:uri").add_text(data[2].to_s))        
    end
     
    title = contribution.dcns.title.to_s
    metadata.add_element(REXML::Element.new("talia:title").add_text(title))
      
    std_title_qry = Query.new(TaliaCore::Source).select(:s).distinct
    std_title_qry.where(contribution, N::HYPER.manifestation_of, :m)
    std_title_qry.where(:m, N::HYPER.siglum, :s)
    material_siglum = std_title_qry.execute[0]
    metadata.add_element(REXML::Element.new("talia:standard_title").add_text(material_siglum))      
      
    metadata.add_element(REXML::Element.new("talia:language").add_text(""))
    date = contribution.dcns.date.to_s
    metadata.add_element(REXML::Element.new("talia:date").add_text(date))
      
    versions = root.add_element(REXML::Element.new("talia:versions"))
    
    case contribution
    when TaliaCore::HyperEdition
      contribution.available_versions.each do |content_version|
        if contribution.hyper.file_content_type[0] == 'hnml'
          # special case for HNML editions/transcriptions (HyperEditions) which have layers
          max_layer = contribution.hnml_max_layer
          if !max_layer.empty?
            i = 1
            while i <= max_layer
              preferred = true unless i != max_layer
              content = contribution.to_html(content_version, i) # calls the XSLT transformation for this version and this layer
              add_version(versions, content_version, i, "talia:content", content, preferred)
            end
          else
            # there are no layers, it'll add the only layer with value "1", it will be the 
            # preferred version too
            content = contribution.to_html(content_version ) # calls the XSLT transformation for this version and this layer
            add_version(versions, content_version, "1", "talia:content", content, true)
          end
        else # it's not HNML
          # there are no layers, it'll add the only layer with value "1", it will be the 
          # preferred version too
          content = contribution.to_html(content_version ) # calls the XSLT transformation for this version and this layer
          add_version(versions, content_version, "1", "talia:content", content, true)
        end
      end
    
    when TaliaCore::Facsimile 
      # no versions for Facsimiles
    when TaliaCore::Essay
      # for essays it will send an URL for the content or several URLs in the case the 
      # essay has several image/PDF, one for each of its page
      content_version = '' # TODO: ??
      url = '' #TODO
      content = '' #TODO
      add_version(versions, content_version, "1", "talia:url", content, true)
    when TaliaCore::Comment
      #TODO: implementation
    when TaliaCore::Path
      #TODO: implementation
    end
    
    macrocontributions = root.add_element(REXML::Element.new("talia:macrocontributions"))

    mc_qry = Query.new(TaliaCore::Source).select(:mc, :m).distinct
    mc_qry.where(contribution, N::HYPER.manifestation_of, :m)
    mc_qry.where(:m, N::HYPER.in_catalog, :mc)
    mc_qry.where(:mc, N::RDF.type, :t)
    mc_qry.where(:t, N::RDFS.subClassOf, N::HYPER.MacroContribution)
    mcs_data = mc_qry.execute
      
    mcs_data.each do |data| unless mcs_data.nil?
        mc_uri = data[0]
        material = data[1]
       
        macrocontribution = macrocontributions.add_element(REXML::Element.new("talia:macrocontribution"))
        macrocontribution.add_element(REXML::Element.new("talia:uri").add_text(mc_uri.to_s))
        #        mc_related_material = data[1]
        book = material.book
        chapter = material.chapter
        path = macrocontribution.add_element(REXML::Element.new("talia:path"))
   
        unless book.nil?
          node = path.add_element(REXML::Element.new("talia:node"))
          node.add_element(REXML::Element.new("talia:granularity").add_text("Book"))
          node.add_element(REXML::Element.new("talia:uri").add_text(book.uri.to_s))
          node.add_element(REXML::Element.new("talia:title").add_text(book.dcns.title.to_s))
          position = ("000000" + book.hyper.position.to_s)[-6..-1]
          node.add_element(REXML::Element.new("talia:position").add_text(position))
        end     
        
        unless chapter.nil?
          node = path.add_element(REXML::Element.new("talia:node"))
          node.add_element(REXML::Element.new("talia:granularity").add_text("Chapter"))
          node.add_element(REXML::Element.new("talia:uri").add_text(chapter.uri.to_s))
          node.add_element(REXML::Element.new("talia:title").add_text(chapter.dcns.title.to_s))
          position = ("000000" + chapter.hyper.position.to_s)[-6..-1]
          node.add_element(REXML::Element.new("talia:position").add_text(position))
        end
          
        node = path.add_element(REXML::Element.new("talia:node"))
        mat_type_qry = Query.new(TaliaCore::Source).select(:t).distinct
        mat_type_qry.where(material, N::RDF.type, :t)
        mat_type_qry.where(:t, N::RDFS.subClassOf, N::HYPER.StructureElement)
        material_type = mat_type_qry.execute[0]
          
        node.add_element(REXML::Element.new("talia:granularity").add_text(material_type.uri.local_name))
        node.add_element(REXML::Element.new("talia:uri").add_text(material.uri.to_s))
        node.add_element(REXML::Element.new("talia:title").add_text(material.dcns.title.to_s))
        case material
        when TaliaCore::Page
          tmp_position = material.hyper.position.to_s
        when TaliaCore::Paragraph
          tmp_position = material.position_in_book
        else
          tmp_position = ''
        end
        position = ("000000" + tmp_position)[-6..-1]
        node.add_element(REXML::Element.new("talia:position").add_text(position))
      end
    end
    doc
  end
  
  private
 
  def add_version(versions_node, content_version, layer, content_tag_name, content, preferred)
    version = versions_node.add_element(REXML::Element.new("talia:version"))
    version.add_element(REXML::Element.new("talia:version_type").add_text(content_version))
    version.add_element(REXML::Element.new("talia:version_layer").add_text(layer))
    version.add_element(REXML::Element.new("talia:preferred").add_text("true")) if preferred
    t = REXML::Text.new(content) 
    content_tag = version.add_element(REXML::Element.new(content_tag_name, nil, {:raw => :all}))
    content_tag.add(t)
    version
  end
  
  
end