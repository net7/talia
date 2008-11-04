module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class PageImporter < Importer
      
      source_type 'hyper:Page'
      
      # When we import the relation to the book, we can also add the
      # relation to 
      on_import_relation N::DCT.isPartOf, :order_page
      
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
        add_property_from(@element_xml, 'position')
        add_property_from(@element_xml, 'position_name')
        import_dimensions!
        clone_to_catalog()
      end
      
      private
      
      # Import the dimensions
      def import_dimensions!
        if((width = @element_xml.elements['width'])&& (height = @element_xml.elements['height']))
          source.dct::extent << "#{width.text.strip}x#{height.text.strip} pixel"
        end
      end
     
      # Creates a clone of the imported page and add to the catalog specified in the xml (if any)
      # also creates the related book in the same catalog
      def clone_to_catalog()
        catalog = get_catalog()
        unless catalog.nil?
          clone_uri = catalog.concordant_uri_for(@source)
          source_book_uri = irify(@source::dct.isPartOf[0])
          clone_book_uri = catalog.uri.local_name.to_s + '/' + source_book_uri.local_name.to_s
          clone_book = get_source_with_class(clone_book_uri, TaliaCore::Book)
          clone_book.save!
          if TaliaCore::Page.exists?(clone_uri)
            clone = TaliaCore::Page.find(clone_uri)
            @source.clone_properties_to(clone, {:catalog => catalog})
          else
            clone = catalog.add_from_concordant(@source)
          end
          clone::dct.isPartOf << clone_book   
          # hack to let order_page use the cloned page          
          @source.autosave_rdf = true
          @source.save!
          #          clone:: rdf.primary_source << @source::rdf.primary_source
          @source = clone
          order_page(clone_book)
        end 
      end
      
    end
  end
end
