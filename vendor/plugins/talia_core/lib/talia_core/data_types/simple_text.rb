require 'talia_core/data_types/file_store'

# Class to manage data stored in a text file
module TaliaCore
  module DataTypes
  
    class SimpleText < FileRecord
    
      # include the module to work with files
      # TODO: paramterize this. If we'll have to work with file inculde the following
      #       otherwise, include the database mixin
      
      # return the mime_type for a file
      def extract_mime_type(location)
        'text/plain'
      end

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
end