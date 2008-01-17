require 'talia_core/local_store/data_record'
require 'talia_core/data_types/file_store'

# Class to manage data stored in a text file
module TaliaCore
  
  class SimpleText < DataRecord
    
    # include the module to work with files
    # TODO: paramterize this. If we'll have to work with file inculde the following
    #       otherwise, include the database mixin
    include FileStore

    # return the mime_type for this specified class
    def mime_type
      'text/plain'
    end
    
    # returns all bytes in the object as an array
    def all_bytes
      read_all_bytes
    end
    
    # Returns the complete text
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
    
    # Set the new position of the reding cursors
    def seek(new_position)
      set_position(new_position)
    end
    
    # returns the size of the object in bytes
    def size
      get_data_size
    end

    # Additional methods for this specific class ====================================

    # Get a line from a text file.
    # At the end of file: close the file and return
    def get_line(close_after_single_read=false)
      if !is_file_open?
        open_file
      end
      
      # get a new line and return nil is EOF
      line = @file_handle.gets
      
      if line == nil or close_after_single_read
        close_file
      end
      
      # update the position of reading cursors
      @position += line.length
      
      return line
    end

 end

end