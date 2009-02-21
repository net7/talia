module TaliaCore
  # The HTML desctription of a catalog may be used in the UI of the catalog itself.
  # An example is the CriticalEdition class which uses this for its "show" action
  class CatalogHtmlDescription < Source
    
    def create_html(html, catalog)
      assit_kind_of(TaliaCore::Catalog, catalog)
      if !self.data_records.empty? 
        data = self.data_records[0]
      else
        data = TaliaCore::DataTypes::XmlData.new
      end
      file_location = catalog.uri.local_name + ".html"
      data.create_from_data(file_location, html)
      self.data_records << data
      self.predicate_replace(:dcns, 'format', 'text/html')
      self.save!
    end
    
    def html
      self.data_records[0].content_string
    end    
  end
end
