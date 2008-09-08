class Feeder
  require "rexml/document"  
  
  def feed_contribution(contribution_uri)
    
    doc = REXML::Document.new
    doc << REXML::XMLDecl.new
    root = REXML::Element.new("talia:source")
    root.add_namespace("talia", "http://www.talia.org")
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
    authors_query.where(contribution, N::HYPER.author, :a)
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
    standard_title = "#{type} of #{material_siglum}"
    metadata.add_element(REXML::Element.new("talia:standard_title").add_text(standard_title))      
      
    metadata.add_element(REXML::Element.new("talia:language").add_text(""))
    date = contribution.dcns.date.to_s
    metadata.add_element(REXML::Element.new("talia:date").add_text(date))
      
    versions = root.add_element(REXML::Element.new("talia::versions"))
    
    case contribution
    when TaliaCore::HyperEdition
      contribution.available_versions.each do |content_version|
        if contribution.hyper.file_content_type[0] == 'hnml'
          # special case for HNML editions/transcriptions (HyperEditions) which have layers
          max_layer = contribution.hnml_max_layer
          if !max_layer.empty?
            i = 1
            while i <= max_layer
              version = versions.add_element(REXML::Element.new("talia::version"))
              version.add_element(REXML::Element.new("talia:version_type").add_text(content_version))
              version.add_element(REXML::Element.new("talia:version_layer").add_text(i))
              version.add_element(REXML::Element.new("talia:preferred").add_text("true")) unless i != max_layer
              content = contribution.to_html(content_version, i) # calls the XSLT transformation for this version and this layer
              version.add_element(REXML::Element.new("talia:content").add_text(content))
            end
          else
            # there are no layers, it'll add the only layer with value "1", it will be the 
            # preferred version too
            version = versions.add_element(REXML::Element.new("talia::version"))
            version.add_element(REXML::Element.new("talia:version_type").add_text(content_version))
            version.add_element(REXML::Element.new("talia:version_layer").add_text('1'))
            version.add_element(REXML::Element.new("talia:preferred").add_text("true"))
            content = contribution.to_html(content_version) # calls the XSLT transformation for this version and this layer
            version.add_element(REXML::Element.new("talia:content").add_text(content))         
          end
          version = versions.add_element(REXML::Element.new("talia::version"))
        else # it's not HNML
          version = versions.add_element(REXML::Element.new("talia::version"))
          version.add_element(REXML::Element.new("talia:version_type").add_text(content_version))
          version.add_element(REXML::Element.new("talia:version_layer").add_text('1'))
          version.add_element(REXML::Element.new("talia:preferred").add_text("true"))
          content = contribution.to_html(content_version) # calls the XSLT transformation for this version and this layer
          version.add_element(REXML::Element.new("talia:content").add_text(content))         
        end
      end
    
    when TaliaCore::Facsimile 
      # no versions for Facsimiles
    when TaliaCore::Essay
      # for essays it will send an URL for the content or several URLs in the case the 
      # essay has several image/PDF, one for each of its page
      
      version = versions.add_element(REXML::Element.new("talia::version"))
      version.add_element(REXML::Element.new("talia:version_type").add_text(content_version))
      version.add_element(REXML::Element.new("talia:version_layer").add_text('1'))
      version.add_element(REXML::Element.new("talia:preferred").add_text("true"))
      url = '' #TODO 
      version.add_element(REXML::Element.new("talia:url").add_text(url))         
 
    when TaliaCore::Comment
      #TODO: implementation
    when TaliaCore::Path
      #TODO: implementation
    end
    
    macrocontributions = root.add_element(REXML::Element.new("talia::macrocontributions"))
      
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
end