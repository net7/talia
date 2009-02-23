module TaliaCore 
  class CriticalEdition < Catalog
    
    # Prefix for edition URIS
    EDITION_PREFIX = 'texts'
    has_rdf_type N::HYPER.CriticalEdition
    
    # returns an array containing a list of all the books of the given type 
    # (manuscripts, works, etc.) or subtype (notebook, draft, etc.) belonging 
    # to this CRITICAL Edition. Books of a subtype also belong to the type
    # of which it is a subtype.
    # Returns all the books in the catalog. See elements
    def books
      types = [N::TALIA.Book]
      elements_by_type(*types)
    end
    
    # it reads the HTML from the given file and create a new CatalogHtmlDescription object
    # which will have a DataRecord related to it, containing the HTML itself.
    # The HTML description is then shown in the first page of a critical edition UI -
    # in the show.html.erb view file.
    def create_html_description!(html_file)
      file = File.new(html_file, "r")
      html = ''
      while (line = file.gets)
        html = html + line
      end
      html_description_uri = self.uri.to_s + "_html_description"
      html_description = TaliaCore::CatalogHtmlDescription.new(html_description_uri)
      html_description.create_html(html, self)
      self.material_description = html_description
      self.save!
    end
    
  end
end