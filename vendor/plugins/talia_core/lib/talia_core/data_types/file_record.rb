module TaliaCore
  module DataTypes
    
    # Base class for all data records that use a plain file for data storage
    class FileRecord < DataRecord
      include FileStore
      extend FileStore::ClassMethods
      
      include PathHelpers
      extend PathHelpers::ClassMethods
      
      include TempFileHandling
      extend TempFileHandling::ClassMethods
      
      after_save :save_attachment
      after_create :write_file_after_save # TODO: Is this really only for create operations
   
      before_destroy :destroy_attachment
      
      
      # returns all bytes in the object as an array
      def all_bytes
        read_all_bytes
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
