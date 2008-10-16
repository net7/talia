module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class PageImporter < Importer
      
      source_type 'hyper:Page'
      
      # When we import the relation to the book, we can also add the
      # relation to 
      on_import_relation N::HYPER.part_of, :order_page
      
      def order_page(book)
        ordered_pages = get_ordered_for(book)
        # Do this "by hand" to save time saving
        ordered_pages.autosave_rdf = false
        predicate = ordered_pages.index_to_predicate(get_text(@element_xml, 'position'))
        ordered_pages[predicate] << @source
        ordered_pages.save!
        ordered_pages.my_rdf[predicate] << @source
        ordered_pages.my_rdf.save
      end
      
      def get_ordered_for(book)
        book = TaliaCore::Book.new(book.uri)
        book.ordered_pages
      end
      
      def import!
        add_property_from(@element_xml, 'width')
        add_property_from(@element_xml, 'height')
        add_property_from(@element_xml, 'position')
        add_property_from(@element_xml, 'position_name')
        source.hyper::dimension_units << 'pixel'
      end
      
    end
  end
end
