module TaliaCore
  module DataTypes
    
    # Class to manage IIP Image data type
    class IipData < DataRecord

      # Returns the IIP server configured for the application
      def self.iip_server_uri
        @iip_server_uri ||= 'http://localhost/fcgi-bin/iipsrv.fcgi'
      end
      
      # return the mime_type for a file
      def extract_mime_type(location)
        'image/tiff'
      end
      
      # returns all bytes in the object as an array
      def all_bytes
        read_all_bytes
      end
      alias :get_thumbnail :all_bytes
      
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
      
      # Additional methods for this specific class ====================================

      # return IIP Server Path
      def iip_server_path
        self.location
      end
      
      # Add data as string into file
      # * location: location
      # * data: data to write
      # * options: options
      def create_from_data(location, data, options = {})
       
        # create name for orginal temp file and destination temp file
        original_file_path = File.join(Dir.tmpdir, "original_#{random_tempfile_filename}")
        destination_file_path = File.join(Dir.tmpdir, "destination_#{random_tempfile_filename}.tif")
        
        # write the original file
        original_file = File.open(original_file_path, 'w')
        original_file << data
        original_file.close
        
        # execute vips command
        # TODO: to add options, such as size, we can modify this row
        vips_command = "vips im_vips2tiff #{original_file_path} #{destination_file_path}:jpeg,tile,pyramid"
        IO.popen(vips_command) {
          sleep(1)
        }
        
        # check if thumbnails file is created
        raise "Vips command failed." unless File.exists?(destination_file_path)
        
        # read thumbnails file
        thumbnails_file = File.open(destination_file_path, 'rb')
        thumbnails_data = thumbnails_file.read(File.size(destination_file_path))
        thumbnails_file.close
        
        # delete temp file
        File.delete original_file_path
        File.delete destination_file_path
      
        # write data
        super(location, thumbnails_data, options)
      end
      
      private
      
      # Generates a unique filename for a Tempfile. 
      def random_tempfile_filename
        "#{rand 10E16}"
      end
      
    end
    
  end
end
