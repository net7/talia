module TaliaCore
  
  class BookHtml < Manifestation
    # creates an HTML version of the whole book passed as argument. starting
    # from HyperEditions which are manifestation of subparts of the book
    def create_html_version_of(book)
      book_text = ''
      book.subparts_with_manifestations(N::HYPER.HyperEdition).each do |part|
        part.manifestations(TaliaCore::HyperEdition).each do |manifestation|
          div_header = "<div class='txt_block' id='#{part.uri.to_s}_text'>"
          #TODO: add the following too, to be calculated.
          # Needed when the full mode is ready
          # <p class="addons"><a href="#">1 facsimile </a>| <a href="#">2 commentaries</a> in <a href="#">Scholar Mode</a></p>       
          div_footer = "</div>"
          book_text += div_header + manifestation.to_html() + div_footer
        end
      end 
      book_text += ''
      if !self.data_records.empty? 
        data = self.data_records[0]
      else
        data = TaliaCore::DataTypes::XmlData.new
      end
      file_location = book.uri.local_name + ".html"
      data.create_from_data(file_location, book_text)
      if self.data_records.empty?
        self.data_records << data
        self.dcns::format << 'text/html'
      end
      self.save!
    end
    
    def html
      self.data_records[0].content_string
    end
  end
end