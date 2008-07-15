
# Base module to manage the data storage in file
# To be included into every subclasse of DataRecord
# which have the necessity to work with file
module FileStore
  
  # the handle for the file
  @file_handle = nil
  # position of the reading cursors
  @position    = 0      
   
  # TODO: Create an object from file
  def create_from_file
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
  
  def write_file_after_save
    # check if there are data to write
    unless @file_data_to_write.nil?
      # check if file already exists
      raise(RuntimeError, "File already exists: #{get_file_path}") if(File.exists?(get_file_path))
          
      begin
        # create data directory path
        FileUtils.mkdir_p(data_directory)
    
        # open file for writing
        @file_handle = File.open(get_file_path, 'w')
      
        # write data string into file
        @file_handle << @file_data_to_write
    
        # close file
        close_file
    
        @file_data_to_write = nil
      rescue Exception => e
        assit_fail("Exception on writing file #{self.location}: #{e}")
      end
    end

  end
    
  # Return the data directory for a specific data file
  def data_directory
    class_name = self.class.name.gsub(/(.*::)/, '')
    File.join(TaliaCore::CONFIG["data_directory_location"], class_name, ("00" + self.id.to_s)[-3..-1])
  end

  # Return true if the specified data file is open, false otherwise
  def is_file_open?
    (@file_handle != nil)
  end

  # Return the full file path related to the data directory
  def get_file_path
    File.join(data_directory, self.id.to_s + File.extname(self.location))
  end

  # private methods ==================================================================
  private
  
  # Open a specified file name and return a file handle.
  # If the file is already opened, return the file handle
  def open_file(file_name = get_file_path, options = 'rb')
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
  def get_next_byte(close)
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

  # Return the data size
  def get_data_size
    File.size(get_file_path)
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

end