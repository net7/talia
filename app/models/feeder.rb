class Feeder
  require "rexml/document"  
  
  def feed_contribution(contribution_uri)
    
    doc = REXML::Document.new
    doc << REXML::XMLDecl.new
    root = REXML::Element.new("talia:source")
    root.add_namespace("talia", "http://www.talia.org")
    doc.add_element(root)
    
    #    qry = Query.new(TaliaCore::Source).select(:contr).distinct
    #    qry.where(:contr, N::HYPER.manifestation_of, :mat)
    #    qry.where(:mat, N::HYPER.in_catalog, :cat)
    #    qry.where(:cat, N::RDF.type, N::TALIA.CriticalEdition)
    #    contributions = qry.execute
    #    
    #    contributions.each do |contribution|

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
          node.add_element(REXML::Element.new("talia:granularity").add_text("book"))
          node.add_element(REXML::Element.new("talia:uri").add_text(book.uri.to_s))
          node.add_element(REXML::Element.new("talia:title").add_text(book.dcns.title.to_s))
          position = ("000000" + book.hyper.position.to_s)[-6..-1]
          node.add_element(REXML::Element.new("talia:position").add_text(position))
        end     
        
        unless chapter.nil?
          node = path.add_element(REXML::Element.new("talia:node"))
          node.add_element(REXML::Element.new("talia:granularity").add_text("chapter"))
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
          tmp_pos_qry = Query.new(TaliaCore::Source).select(:page_pos, :note_pos).distinct
          tmp_pos_qry.where(material, N::HYPER.note, :n)
          tmp_pos_qry.where(:n, N::HYPER.page, :page)
          tmp_pos_qry.where(:page, N::HYPER.position, :page_pos)
          tmp_pos_qry.where(:n, N::HYPER.position, :note_pos)
          res = tmp_pos_qry.execute[0]
          tmp_position = res[0] + res[1]
        else
          tmp_position =''
        end
        position = ("000000" + tmp_position)[-6..-1]
        node.add_element(REXML::Element.new("talia:position").add_text(position))
          
          
      end
    end
    doc
      
  end
    
  #  end
end