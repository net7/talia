module TaliaCore
  module DataTypes
    
    # Class to manage IIP Image data type
    class IipData < DataRecord

      after_save :upload_pyramid_file_after_save
        
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
      # * data: data to write
      # * options: options
      #   *  options[:thumbnail_size]: Hash. Size of thumbnail file (it must be a multiple of 16.
      def create_from_data(data, options = {:thumbnail_size => {:width => 128, :height => 128}})
       
        # create name for orginal temp file and destination temp file
        original_file_path = File.join(Dir.tmpdir, "original_#{random_tempfile_filename}")
        destination_thumbnail_file_path = File.join(Dir.tmpdir, "thumbnail_#{random_tempfile_filename}.tif")
        destination_pyramid_file_path = File.join(Dir.tmpdir, "pyramid_#{random_tempfile_filename}.tif")
        
        # write the original file
        original_file = File.open(original_file_path, 'w')
        original_file << data
        original_file.close
        
        # execute vips command for create thumbnail
        # TODO: to add options, such as size, we can modify this row
        thumbnail_size = "#{options[:thumbnail_size][:width]}x#{options[:thumbnail_size][:height]}"
        system_result = system("vips im_vips2tiff #{original_file_path} #{destination_thumbnail_file_path}:jpeg:75,tile:#{thumbnail_size}")

        # check if thumbnails file is created
        raise "Vips command failed (#{$?})." unless (File.exists?(destination_thumbnail_file_path) || system_result == false)
        
        # execute vips command for create pyramid image
        # TODO: to add options, such as size, we can modify this row
        system_result = system("vips im_vips2tiff #{original_file_path} #{destination_pyramid_file_path}:jpeg,tile,pyramid")

        # check if thumbnails file is created
        raise "Vips command failed (#{$?})." unless (File.exists?(destination_pyramid_file_path) || system_result == false)
        
        # read thumbnails file
        thumbnails_file = File.open(destination_thumbnail_file_path, 'rb')
        thumbnails_data = thumbnails_file.read(File.size(destination_thumbnail_file_path))
        thumbnails_file.close
        
        # delete temp file
        File.delete original_file_path
        File.delete destination_thumbnail_file_path
        
        # store pyramid file path to temp variable
        @pyramid_file = destination_pyramid_file_path
      
        # write data
        super("", thumbnails_data, options)
      end
      
      private
      
      # upload pyramid file to IIP Server
      def upload_pyramid_file_after_save
        # check if there are file to move
        unless @pyramid_file.nil?
          # check if file already exists
          raise(RuntimeError, "File already exists: #{get_iip_root_file_path}") if(File.exists?(get_iip_root_file_path))
          
          begin
            # set location
            self.location = get_iip_root_file_path(true)
            
            # create data directory path
            FileUtils.mkdir_p(iip_root_directory)
            
            # move file
            FileUtils.cp @pyramid_file, get_iip_root_file_path
            FileUtils.rm @pyramid_file
            @pyramid_file = nil
          rescue Exception => e
            assit_fail("Exception on moving file from #{@pyramid_file} to #{get_iip_root_file_path}: #{e}")
          end
        end

      end
      
      # Return the iip root directory for a specific iip image file
      def iip_root_directory(relative = false)
        if relative == false
          File.join(TaliaCore::CONFIG["iip_root_directory_location"], ("00" + self.id.to_s)[-3..-1])
        else
          File.join(("00" + self.id.to_s)[-3..-1])
        end
      end
      
      # Return the full file path related to the data directory
      def get_iip_root_file_path(relative = false)
        File.join(iip_root_directory(relative), self.id.to_s + '.tif')
      end
  
      # Generates a unique filename for a Tempfile. 
      def random_tempfile_filename
        "#{rand 10E16}"
      end
      
    end
    
  end
end
