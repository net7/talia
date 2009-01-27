module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class ChapterImporter < Importer
      
      source_type 'hyper:Chapter'
      
      def import!
        add_property_from(@element_xml, 'position')
        add_property_from(@element_xml, 'name')
        add_rel_from(@element_xml, 'book')
        add_rel_from(@element_xml, 'first_page')
#        clone_to_catalog()
      end
      
      private
      
      # Creates a clone of the imported chapter and add to the catalog specified in the xml (if any)
      # also creates the related book and (first) page in the same catalog
      def clone_to_catalog()
        catalog = get_catalog()
        unless catalog.nil?
          clone_uri = catalog.concordant_uri_for(@source)
          source_book_uri = irify(@source::hyper.book[0])
          clone_book_uri = catalog.uri.local_name.to_s + '/' + source_book_uri.local_name.to_s
          clone_book = get_source_with_class(clone_book_uri, TaliaCore::Book)
          source_first_page_uri = irify(@source::hyper.first_page[0])
          clone_first_page_uri = catalog.uri.local_name.to_s + '/' + source_first_page_uri.local_name.to_s
          clone_first_page =  get_source_with_class(clone_first_page_uri, TaliaCore::Page)
          clone_to(clone_uri) do |clone|
            quick_add_predicate(clone, N::HYPER.book, clone_book)
            quick_add_predicate(clone, N::HYPER.first_page, clone_first_page)
            clone.save!
          end
        end
      end
      
    end
  end
end
