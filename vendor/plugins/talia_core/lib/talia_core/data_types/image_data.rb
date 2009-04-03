module TaliaCore
  module DataTypes
    
    # Class to manage image data type
    class ImageData < FileRecord
      
      # return the mime_type for a file
      def extract_mime_type(location)
        case File.extname(location).downcase
        when '.bmp'
          'image/bmp'
        when '.cgm'
          'image/cgm'
        when '.fit', '.fits'
          'image/fits'
        when '.g3'
          'image/g3fax'
        when '.gif'
          'image/gif'
        when '.jpg', '.jpeg', '.jpe'
          'image/jpeg'
        when '.png'
          'image/png'
        when '.tif', '.tiff'
          'image/tiff'
        end
      end
       
    end
    
  end
end