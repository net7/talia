class Feeder

  def feed_contribution(contribution_uri)
    require 'net/http'
    xml = create_contribution_xml(contribution_uri)
    
    # load exist options.
    exist_options = TaliaCore::CONFIG['exist_options']
    raise "eXist configuration not found." if exist_options.nil?
    
    # set options
    exist_servlet_url = URI.parse(URI.join(exist_options['server_url'],"/#{exist_options['community']}/FeedExist/store").to_s)
    exist_login = exist_options['exist_login']
    exist_password = exist_options['exist_password']
    
    params = {'xml' => xml}
    req = Net::HTTP::Post.new(exist_servlet_url.path)
    req.basic_auth exist_login, exist_password
    req.set_form_data(params)
    res = Net::HTTP.new(exist_servlet_url.host, exist_servlet_url.port).start {|http| http.request(req) }
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      res.body
    else
      puts "Error for #{exist_servlet_url}"
      puts res.body
      res.error!
    end
  end
  
  def create_contribution_xml(contribution_uri)
    require "rexml/document"  
  
    doc = REXML::Document.new
    doc << REXML::XMLDecl.new
    root = REXML::Element.new("talia:source")
    
    # add namespace to xml file
    exist_namespace = TaliaCore::CONFIG['exist_options']['exist_namespace']
    root.add_namespace("talia", exist_namespace)
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
    
    # add the subtype (if it exists, AvMedia don't have it, for instance)    
    metadata.add_element(REXML::Element.new("talia:subtype").add_text(subtype.uri.local_name)) unless subtype.nil? 
    # add the URI of the contribution
    metadata.add_element(REXML::Element.new("talia:uri").add_text(contribution.uri.to_s))

    # add authors relations
    authors_query = Query.new(TaliaCore::Source).select(:n, :s, :a).distinct
    authors_query.where(contribution, N::DCNS.creator, :a)
    authors_query.where(:a, N::HYPER.author_name, :n)
    authors_query.where(:a, N::HYPER.author_surname, :s)
  
    authors_data = authors_query.execute
      
    authors = metadata.add_element(REXML::Element.new("talia:authors"))
    
    # AvMedia sources don't have a normal relation with authors.
    # The authors of them are stored as plain text (and no author is created in the system)
    # In such a case we must add the full author text (name and surname) in the firstname tag.
    if (type == 'AvMedia')
      author = authors.add_element(REXML::Element.new("talia:author"))
      author_full_name = contribution::dcns.creator.first
      author.add_element(REXML::Element.new("talia:firstname").add_text(author_full_name))
      author.add_element(REXML::Element.new("talia:lastname"))
      author.add_element(REXML::Element.new("talia:uri"))        
    else
      authors_data.each do |data|
        author = authors.add_element(REXML::Element.new("talia:author"))
        author.add_element(REXML::Element.new("talia:firstname").add_text(data[0]))
        author.add_element(REXML::Element.new("talia:lastname").add_text(data[1]))
        author.add_element(REXML::Element.new("talia:uri").add_text(data[2].to_s))        
      end
    end
    
    # add the title
    title = contribution.dcns.title.to_s
    metadata.add_element(REXML::Element.new("talia:title").add_text(title))
      
    # AvMedia sources have the title also in the standard_title
    if (type == 'AvMedia')    
      metadata.add_element(REXML::Element.new("talia:standard_title").add_text(title))      
    else
      # others contributions have the related material siglum in there
      std_title_qry = Query.new(TaliaCore::Source).select(:s).distinct
      std_title_qry.where(contribution, N::HYPER.manifestation_of, :m)
      std_title_qry.where(:m, N::HYPER.siglum, :s)
      material_siglum = std_title_qry.execute[0]
      metadata.add_element(REXML::Element.new("talia:standard_title").add_text(material_siglum))      
    end  
    
    metadata.add_element(REXML::Element.new("talia:language").add_text(""))
    date = contribution.dcns.date.to_s
    metadata.add_element(REXML::Element.new("talia:date").add_text(date))

    # AvMedia also have some extra data to be fed
    if (type == 'AvMedia')
      #FIXME: actually in the RDF there is no such thing as the publication date...
      # the publication date is in the mysql db, 
      # metadata.add_element(REXML::Element.new("talia:creation_date").add_text(#TODO))
      # add the length of the AvMedia file
      length = contribution::dct.extent.first
      metadata.add_element(REXML::Element.new("talia:length").add_text(length))
      # add the bibliography
      bibliography = contribution::hyper.bibliography.first
      metadata.add_element(REXML::Element.new("talia:bibliography").add_text(bibliography))
      # add all the keywords (just the name) #TODO: check if names are OK here
      keywords = metadata.add_element(REXML::Element.new("talia:keywords"))
      keywords_query = Query.new(TaliaCore::Source).select(:key_name).distinct
      keywords_query.where(contribution, N::HYPER.keyword, :keyword)
      keywords_query.where(:keyword, N::HYPER.keyword_value, :key_name)
      keywords_query.execute.each do |keyword| 
        keywords.add_element(REXML::Element.new("talia:keyword").add_text(keyword))
      end
    end
  
    macrocontributions = root.add_element(REXML::Element.new("talia:macrocontributions"))

    mc_qry = Query.new(TaliaCore::Source).select(:mc, :m).distinct
    mc_qry.where(contribution, N::HYPER.manifestation_of, :m)
    mc_qry.where(:m, N::HYPER.in_catalog, :mc)
    mc_qry.where(:mc, N::RDF.type, :t)
    mc_qry.where(:t, N::RDFS.subClassOf, N::HYPER.MacroContribution)
    mcs_data = mc_qry.execute

    mc_version = nil

    mcs_data.each do |data| unless mcs_data.nil?
        mc = data[0]
        material = data[1]
        mc_version = mc.hyper::version[0]
        # if a version wasn't requested at creation time, this means the default
        # version was used. The same version we must feed
        mc_version = 'default' if mc_version.nil?
        macrocontribution = macrocontributions.add_element(REXML::Element.new("talia:macrocontribution"))
        macrocontribution.add_element(REXML::Element.new("talia:uri").add_text(mc.to_s))
        #        mc_related_material = data[1]
        book = material.book
        chapter = material.chapter
        path = macrocontribution.add_element(REXML::Element.new("talia:path"))
   
        unless book.nil?
          node = path.add_element(REXML::Element.new("talia:node"))
          node.add_element(REXML::Element.new("talia:granularity").add_text("Book"))
          node.add_element(REXML::Element.new("talia:uri").add_text(book.uri.to_s))
          node.add_element(REXML::Element.new("talia:title").add_text(book.dcns.title.to_s))
          position = book.position_for_search_key
          node.add_element(REXML::Element.new("talia:position").add_text(position))
        end     
        
        unless chapter.nil?
          node = path.add_element(REXML::Element.new("talia:node"))
          node.add_element(REXML::Element.new("talia:granularity").add_text("Chapter"))
          node.add_element(REXML::Element.new("talia:uri").add_text(chapter.uri.to_s))
          node.add_element(REXML::Element.new("talia:title").add_text(chapter.dcns.title.to_s))
          position = chapter.position_for_search_key
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
          position =  material.position_for_search_key
        when TaliaCore::Paragraph
          position = material.position_for_search_key
        else
          position = '000000'
        end
        node.add_element(REXML::Element.new("talia:position").add_text(position))
      end
    end

    versions = root.add_element(REXML::Element.new("talia:versions"))

    case contribution
    when TaliaCore::HyperEdition
      case mc_version
      when nil
        contribution.available_versions.each do |content_version|
          add_hyper_edition_versions(contribution, versions, content_version)
        end
      when 'default'
        content_version = contribution.available_versions[0]
        add_hyper_edition_versions(contribution, versions, content_version)
      else
        add_hyper_edition_versions(contribution, versions, mc_version)
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
      #    when TaliaCore::Comment
      #TODO: implementation
    when TaliaCore::Path
      #TODO: implementation
    when TaliaCore::AvMedia
      version = versions.add_element(REXML::Element.new("talia:version"))
      content = version.add_element(REXML::Element.new("talia:content"))
      abstract = contribution::dcns.abstract.first
      content.add_element(REXML::Element.new("talia:abstract").add_text(abstract))
    end


    doc
  end
  
  private

  # adds one version of the contribution content to the "versions" node
  # each version contains, possibly, a different render of the same contribution content
  # (this is the case of HyperEdition, for instance, where, starting from a single
  # XML file, more versions can be rendered, by using different XSLT)
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

  # HyperEditions has to deal with different XML encoding, each of which has its
  # own special cases, versions, ecc.
  def add_hyper_edition_versions(contribution, versions, content_version)
    if contribution.dcns::format.first == 'application/xml+hnml'
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
end