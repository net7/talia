module TaliaCore
  module DataTypes
    
    # Class to manage IIP Image data type
    class IipData < DataRecord

      # return the mime_type for a file
      def extract_mime_type(location)
        'image/tiff'
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
