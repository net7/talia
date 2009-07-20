module TaliaUtil
  
  module HyperImporter
    
    # Import class for facsimiles
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
        @source.blank = 'true' unless(has_file?)
      end

      def has_file?
        all_strings?('file_name', 'file_url', 'file_content_type')
      end
      
      # True if all properties are non-empty strings
      def all_strings?(*str)
        all_strings = true
        str.each do |el|
          el_str = get_text(@element_xml, el)
          all_strings = (all_strings && el_str && el_str != '')
        end
        all_strings
      end

    end
  end
end
