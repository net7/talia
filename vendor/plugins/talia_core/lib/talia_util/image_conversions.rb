module TaliaUtil

  # Helper class that provides an interface to convert images, create
  # thumbnails and pyramid images. This provides a central point from which to
  # call external conversion tools.
  #
  # Since it calls the command line, it should be compatible both with JRuby
  # and plain Ruby.
  class ImageConversions

    class << self

      # Returns the command that is used for converting images
      def vips_command
        @vips_command ||= if(defined?(TaliaCore))
          TaliaCore::CONFIG['vips_command'] || '/opt/local/bin/vips'
        elsif(defined?(VIPS_COMMAND))
          VIPS_COMMAND
        else
          raise(ArgumentError('Unconfigured vips command. If not in Talia, set VIPS_COMMAND'))
        end
      end

      # Returns the command that is used for converting thumbnails
      def convert_command
        @convert_command ||= if(defined?(TaliaCore))
          TaliaCore::CONFIG['convert_command'] || '/opt/local/bin/convert'
        elsif(defined?(CONVERT_COMMAND))
          CONVERT_COMMAND
        else
          raise(ArgumentError('Unconfigured convert command. If not in Talia, set CONVERT_COMMAND'))
        end
      end

      # Returns the options for the thumbnail
      def thumb_options
        @thumb_options ||= if(defined?(TaliaCore))
          TaliaCore::CONFIG['thumb_options'] || { 'width' => '80', 'height' => '120' }
        elsif(defined?(THUMB_OPTIONS))
          THUMB_OPTIONS
        else
          raise(ArgumentError('Unconfigured thumbnail options. If not in Talia, set THUMB_OPTIONS'))
        end
      end

      # Create the thumbnail by running the configured creation command.
      def create_thumb(source, destination)
        thumbnail_size = "#{thumb_options['width']}x#{thumb_options['height']}"
        thumbnail_command = "#{convert_command} \"#{source}\" -quality 85 -thumbnail \"#{thumbnail_size}>\" -background transparent -gravity center -extent #{thumbnail_size} \"#{destination}\""
        execute_command(thumbnail_command, destination)
      end

      # Creates the pyramid image for IIP by running the configured system
      # command. This automatically creates the file in the correct location
      # (IIP root)
      def create_pyramid(source, destination)
        pyramid_command = "#{vips_command} im_vips2tiff \"#{source}\" \"#{destination}\":jpeg:75,tile:256x256,pyramid"
        execute_command(pyramid_command, destination)
      end

      # Transforms the given image into a PNG image. Note that the .png suffix
      # will automatically added to the destination name
      def to_png(source, destination)
        convert_line = "#{convert_command} \"#{source}\" \"#{destination}.png\""
        execute_command(convert_line, "#{destination}.png")
      end

      private

      # Executes the given command and raises an error if not successful.
      # The error will also be raised if a file is given and does not exist.
      def execute_command(command, file_to_exist = nil)
        system_result = system(command)
        # check if successful
        raise(IOError, "Command #{command} failed (#{$?}).") unless ((file_to_exist && File.exists?(file_to_exist)) || !system_result)
      end

    end
  end
end

