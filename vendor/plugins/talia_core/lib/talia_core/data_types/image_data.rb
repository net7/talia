module TaliaCore
  module DataTypes
    # Class to manage image data type
    class ImageData < DataRecord
    
      # include the module to work with files
      # TODO: paramterize this. If we'll have to work with file inculde the following
      #       otherwise, include the database mixin
      #include FileStore

      # return the mime_type for this specified class
      def mime_type
        case File.extname(get_file_path)
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
    
      # returns all bytes in the object as an array
      def all_bytes
        read_all_bytes
      end
    
      # returns the complete text
      def all_text
        if(!is_file_open?)
          open_file
        end
        @file_handle.read(self.size)
      end

      # returns the next byte from the object, or nil at EOS
      def get_byte(close_after_single_read=false)
        get_next_byte(close_after_single_read)
      end

      # returns the current position of the read cursor (binary access)
      def position
        return (@position != nil) ? @position : 0
      end
   
      # reset the cursor to the initial state
      def reset
        set_position(0)
      end
    
      # set the new position of the reding cursors
      def seek(new_position)
        set_position(new_position)
      end
    
      # returns the size of the object in bytes
      def size
        get_data_size
      end
    
    end
  end
end