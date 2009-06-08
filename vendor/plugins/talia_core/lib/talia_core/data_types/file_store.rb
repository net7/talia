require 'fileutils'

module TaliaCore
  # Base module to manage the data storage in file
  # To be included into every subclasse of DataRecord
  # which have the necessity to work with file
  module DataTypes
    module FileStore
  
      # the handle for the file
      @file_handle = nil
      # position of the reading cursors
      @position    = 0      
   
      # Class for data paths
      class DataPath < String ; end
      
      module ClassMethods
      
        # Find or create a record for the given location and source_id, then it saves the given file.
        def find_or_create_and_assign_file(params)
          data_record = self.find_or_create_by_location_and_source_id(extract_filename(params[:file]), params[:source_id])
          data_record.file = params[:file]
          data_record.save # force attachment save and it also saves type attribute.
        end
      
      end
    
      # This will create the data object from a given file. This will simply move the
      # given file to the correct location upon save. This will avoid multiple
      # read/write operations during import.
      #
      # The original file must not be touched by external processes until the
      # record is saved.
      #
      # If the delete_original flag is set, the original file will be removed
      # on save
      def create_from_file(location, file_path, delete_original = false)
        close_file
        self.location = location
        @file_data_to_write = DataPath.new(file_path)
        @delete_original_file = delete_original
      end
  
      # Add data as string into file
      def create_from_data(file_location, data, options = {})
        # close file if opened
        close_file
    
        # Set the location for the record
        self.location = file_location
    
        if(data.respond_to?(:read))
          @file_data_to_write = data.read
        else
          @file_data_to_write = data
        end
    
      end
      
      # returns the complete text
      def all_text
        if(!is_file_open?)
          open_file
        end
        @file_handle.read(self.size)
      end
  
      # This is a placeholder in case file is used in a form.
      def file() nil; end
    
      # Assign the file data (<tt>StringIO</tt> or <tt>File</tt>).
      def file=(file_data)
        return nil if file_data.nil? || file_data.size == 0 
        self.assign_type file_data.content_type
        self.location = file_data.original_filename if respond_to?(:location)
        if file_data.is_a?(StringIO)
          file_data.rewind
          self.temp_data = file_data.read
        else
          self.temp_path = file_data.path
        end
        @save_attachment = true
      end
    
      def write_file_after_save 
        # check if there are data to write
        return unless(@file_data_to_write)
    
        # check if file already exists
#        raise(RuntimeError, "File already exists: #{file_path}") if(File.exists?(file_path))

        begin
          self.class.benchmark("\033[36m\033[1m\033[4mFileStore\033[0m Saving file for #{self.id}") do
            # create data directory path
            FileUtils.mkdir_p(data_directory)
    
            if(@file_data_to_write.is_a?(DataPath))
              copy_data_file
            else
              save_cached_data
            end
          
            @file_data_to_write = nil
          end
        rescue Exception => e
          assit_fail("Exception on writing file #{self.location}: #{e}")
        end

      end
   
      # Return true if the specified data file is open, false otherwise
      def is_file_open?
        (@file_handle != nil)
      end

      # private methods ==================================================================
      private
  
      
      # This saves the cached data from the file creation
      def save_cached_data
        # open file for writing
        @file_handle = File.open(file_path, 'w')
      
        # write data string into file
        @file_handle << (@file_data_to_write.respond_to?(:read) ? @file_data_to_write.read : @file_data_to_write)
    
        # close file
        close_file
    
      end
      
      # This copies the data file with which this object was created to the
      # actual storage lcoation
      def copy_data_file
        copy_or_move(@file_data_to_write, file_path)
      end
      
      # Open a specified file name and return a file handle.
      # If the file is already opened, return the file handle
      def open_file(file_name = file_path, options = 'rb')
        # chek if the file name really exists, otherwise raise an exception
        if !File.exists?(file_name)
          raise(IOError, "File #{file_name} could not be opened.", caller)
        end
    
        # try to open the specified file if is not already open
        if @file_handle == nil
          @file_handle = File.open(file_name, options)
      
          # check and set the initial position of the reading cursors.
          # It's necessary to do this thing because we don't know if the user
          # has specified the initial reading cursors befort starting working on file
          @position ||= @file_handle.pos
      
          @file_handle.pos = @position
        end
      end

      # Close an already opened file
      def close_file
        if is_file_open?
          @file_handle.close
      
          # reset 'flags' variables and position
          @file_handle = nil
          @position    = 0
        end
      end

      # Read all bytes from a file  
      def read_all_bytes
        # 1. Open file with option "r" (reading) and "b" (binary, useful for window system)
        open_file
      
        # 2. Read all bytes
        begin
          bytes = @file_handle.read(self.size).unpack("C*")
          return bytes
        rescue
          # re-raise system the excepiton
          raise
          return nil
        ensure
          # 3. Close the file
          close_file
        end
      end

      # return the next_byte
      def next_byte(close)
        if !is_file_open?
          open_file
        end
    
        begin
          current_byte = @file_handle.getc
      
          if current_byte == nil or close
            close_file
          else
            @position += 1
          end

          return current_byte
        rescue
          # re-raise system the excepiton
          raise
          close_file
          return nil
        end
    
      end

      # Copy or move the source file to the target. Working around all the
      # things that suck in JRuby. This will honour two environment settings:
      # 
      # * delay_file_copies - will not copy the files, but create a batch file
      #     so that the copy can be done later. Uses the DelayedCopier class.
      # * fast_copies - will use the "normal" copy method from FileUtils that
      #     is faster. Since it crashed the system for us, the default is to
      #     use a "safe" workaround. The workaround is probably necessary for
      #     JRuby only.
      def copy_or_move(original, target)
        if(@delete_original_file)
          FileUtils.move(original, target)
        else
          # Delay can be enabled through enviroment
          if(delay_copies)
            DelayedCopier.cp(original, target)
          elsif(fast_copies)
            FileUtils.copy(original, target)
          else
            # Call the copy as an external command. This is to work around the
            # crashes that occurred using the builtin copy
            from_file = File.expand_path(original)
            to_file = File.expand_path(target)
            system_success = system("cp '#{from_file}' '#{to_file}'")
            raise(IOError, "copy error '#{from_file}' '#{to_file}'") unless system_success
          end
        end
      end
      
      
      # Returns true if the 'delayed write' is enabled in the environment
      def delay_copies
        ENV['delay_file_copies'] == 'true' || ENV['delay_file_copies'] == 'yes'
      end
        
      # Returns true if the 'fast copy' is enabled in the environment.
      # Otherwise the class will use a workaround that is less likely to 
      # crash the whole system using JRuby.
      def fast_copies
        ENV['fast_copies'] == 'true' || ENV['fast_copies'] == 'yes'
      end
      
      # Return the data size
      def data_size
        File.size(file_path)
      end

      # set the position of the reading cursor
      def set_position(position)
        if (position != nil and position =~ /\A\d+\Z/)
          if (position < size)
            set_position(position)
          else
            raise(IOError, 'Position out of range', caller)
          end
        else
          raise(IOError, 'Position not valid. It must be an integer')
        end
      end
    
      # Check if the attachment should be saved.
      def save_attachment?
        @save_attachment
      end
    
      # Save the attachment, copying the file from the temp_path to the data_path.
      def save_attachment
        return unless save_attachment?
        save_file
        @save_attachment = false
        true
      end

      # Destroy the attachment
      def destroy_attachment
        FileUtils.rm(full_filename) if File.exists?(full_filename)
      end

      # Save the attachment on the data_path directory.
      def save_file
        FileUtils.mkdir_p(File.dirname(full_filename))
        FileUtils.cp(temp_path, full_filename)
        FileUtils.chmod(0644, full_filename)
      end

    end
  end
end