module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class FacsimileImporter < ContributionImporter
      
      source_type 'hyper:Facsimile'

      @@empty_thumb = File.join(TALIA_ROOT, 'public', 'images', 'empty_page_thumb.gif')

      def import!
        contribution_import!
        import_dimensions!
        check_for_empty_file!
      end
      
      # Import the dimensions
      def import_dimensions!
        width = @element_xml.elements['dimensionX']
        height = @element_xml.elements['dimensionY']
        if(width.text && height.text)
          quick_add_predicate(source, N::DCT.extent, "#{width.text.strip}x#{height.text.strip} pixel")
        end
      end

      # Add a default thumb image if the page is empty
      def check_for_empty_file!
        @source.blank = 'true'unless(has_file?)
      end

      def has_file?
        file_name = get_text(@element_xml, 'file_name')
        file_url = get_text(@element_xml, 'file_url')
        file_content_type = get_text(@element_xml, 'file_content_type')
        file_name && file_url && file_content_type
      end
      
    end
  end
end
