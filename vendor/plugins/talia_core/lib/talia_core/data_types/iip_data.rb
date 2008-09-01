module TaliaCore
  module DataTypes
    
    # Class to manage IIP Image data type
    class IipData < DataRecord
        
      # Returns the IIP server configured for the application
      def self.iip_server_uri
        TaliaCore::CONFIG['iip_server_uri'] ||= 'http://localhost/fcgi-bin/iipsrv.fcgi'
      end
      
      # Returns the command that is used for converting images
      def vips_command
        TaliaCore::CONFIG['vips_command'] ||= '/opt/local/bin/vips'
      end
      
      # Returns the command that is used for converting thumbnails
      def convert_command
        TaliaCore::CONFIG['convert_command'] ||= '/opt/local/bin/convert'
      end
      
      # Returns the options for the thumbnail
      def thumb_options
        TaliaCore::CONFIG['thumb_options'] ||= { 'width' => '128', 'height' => '128' }
      end
      
      # This is the mime type for the thumbnail - always tiff
      def set_mime_type
        self.mime = 'image/jpeg'
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
      
      def write_file_after_save
        return unless(@file_data_to_write)
        
        # create name for orginal temp file and destination temp file
        original_file_path = File.join(Dir.tmpdir, "original_#{random_tempfile_filename}")
        destination_thumbnail_file_path = File.join(Dir.tmpdir, "thumbnail_#{random_tempfile_filename}.jpg")
        destination_pyramid_file_path = File.join(Dir.tmpdir, "pyramid_#{random_tempfile_filename}.tif")
        
        begin # Begin the file creation operationo
          # write the original file
          File.open(original_file_path, 'w') do |original_file|
            if(@file_data_to_write.respond_to?(:read))
              original_file << @file_data_to_write.read
            else
              original_file << @file_data_to_write
            end
          end
        
          # execute vips command for create thumbnail
          # TODO: to add options, such as size, we can modify this row
          thumbnail_size = "#{thumb_options['width']}x#{thumb_options['height']}"
          thumbnail_command = "#{convert_command} #{original_file_path} -resize #{thumbnail_size} #{destination_thumbnail_file_path}"
          system_result = system(thumbnail_command)

          # check if thumbnails file is created
          raise(IOError, "Vips command failed (#{$?}).") unless (File.exists?(destination_thumbnail_file_path) || !system_result)
        
          # execute vips command for create pyramid image
          # TODO: to add options, such as size, we can modify this row
          pyramid_command = "#{vips_command} im_vips2tiff #{original_file_path} #{destination_pyramid_file_path}:deflate  ,tile,pyramid"
          system_result = system(pyramid_command)

          # check if thumbnails file is created
          raise(IOError, "Vips command failed (#{$?}).") unless (File.exists?(destination_pyramid_file_path) || !system_result)
        
          # Run the super implementation for the thumbnail
          File.open(destination_thumbnail_file_path, 'rb') do |thumb_file|
            @file_data_to_write = thumb_file
            super
          end
          
          # Copy the pyramid image to the final location
          move_pyramid_file(destination_pyramid_file_path)
          
        ensure
          # delete temp files
          File.delete original_file_path if(File.exists?(original_file_path))
          File.delete destination_thumbnail_file_path if(File.exists?(destination_thumbnail_file_path))
          File.delete destination_pyramid_file_path if(File.exists?(destination_pyramid_file_path))
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
      
      private
      
      # Copy the pyramid file to the IIP directory
      def move_pyramid_file(pyramid_file)
        # check if file already exists
        raise(IOError, "File already exists: #{get_iip_root_file_path}") if(File.exists?(get_iip_root_file_path))
          
        begin
          # set location
          self.location = get_iip_root_file_path(true)
            
          # create data directory path
          FileUtils.mkdir_p(iip_root_directory)
            
          # move file
          FileUtils.cp pyramid_file, get_iip_root_file_path
          FileUtils.rm pyramid_file
        rescue Exception => e
          assit_fail("Exception on moving file from #{pyramid_file} to #{get_iip_root_file_path}: #{e}")
        end
      end
  
      # Generates a unique filename for a Tempfile. 
      def random_tempfile_filename
        "#{rand 10E16}"
      end
      
    end
    
  end
end
