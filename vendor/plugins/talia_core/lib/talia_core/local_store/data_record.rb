require 'active_record'
require 'action_controller/mime_type'
require 'talia_core/data_types/data_types_loader'
require 'initializer'
require 'ftools'

module TaliaCore
  
  # ActiveRecord interface to the data record in the database
  class DataRecord < ActiveRecord::Base
    # Path used to store temporary files.
    def tempfile_path
      @@tempfile_path ||= File.join(TALIA_ROOT, 'tmp', 'data_records')
    end
    
    # Path used to store data files.
    def data_path
      @@data_path ||= File.join(TALIA_ROOT, 'data')
    end
    
    def before_save
      return unless save_attachment?
      assign_location
      assign_mime_type
      save_attachment
    end

    # Declaration of main abstract methods ======================
    # Some notes: every subclasses of DataRecord must implement
    #             at least the following methods
    # See also:   single-table inheritance    

    # returns all bytes in the object as an array of unsigned integers
    def all_bytes
    end
    
    # Returns all_bytes as an binary string
    def content_string
      all_bytes.pack('C*') if(all_bytes)
    end

    # returns the next byte from the object, or nil at EOS  
    def get_byte(close_after_single_read=false)
    end
    
    # return a string corresponding to the MIME type
    def mime_type    
    end
    
    # returns the current position of the read cursor
    def position
    end
    
    # adjust the position of the read cursor
    def seek(new_position)
    end

    # returns the size of the object in bytes
    def size
    end
    
    # reset the cursor to the initial state
    def reset
    end
    
    # class methods ============================================
    
    # TODO: return the data checksum 
    def checksum
    end

    # TODO: an iterator that calls a block on each byte in the object
    def each_byte
    end
    
    attr_accessor :content_type
    attr_accessor :filename
    attr_accessor :temp_path
    
    # This is a placeholder in case file is used in a form.
    def file() nil; end
    
    # Assign the file data (<tt>StringIO</tt> or <tt>File</tt>).
    def file=(file_data)
      return nil if file_data.nil? || file_data.size == 0 
      self.content_type = file_data.content_type
      self.filename     = file_data.original_filename if respond_to?(:filename)
      if file_data.is_a?(StringIO)
        file_data.rewind
        self.temp_data = file_data.read
      else
        self.temp_path = file_data.path
      end
    end
    
    # Gets the latest temp path from the collection of temp paths.  While working with an attachment,
    # multiple Tempfile objects may be created for various processing purposes (resizing, for example).
    # An array of all the tempfile objects is stored so that the Tempfile instance is held on to until
    # it's not needed anymore.  The collection is cleared after saving the attachment.
    def temp_path
      p = temp_paths.first
      p.respond_to?(:path) ? p.path : p.to_s
    end
    
    # Gets an array of the currently used temp paths.  Defaults to a copy of #full_filename.
    def temp_paths
      @temp_paths ||= (new_record? || !File.exist?(full_filename)) ? [] : [copy_to_temp_file(full_filename)]
    end
    
    # Adds a new temp_path to the array.  This should take a string or a Tempfile.  This class makes no 
    # attempt to remove the files, so Tempfiles should be used.  Tempfiles remove themselves when they go out of scope.
    # You can also use string paths for temporary files, such as those used for uploaded files in a web server.
    def temp_path=(value)
      temp_paths.unshift value
      temp_path
    end

    # Gets the data from the latest temp file.  This will read the file into memory.
    def temp_data
      save_attachment? ? File.read(temp_path) : nil
    end
    
    # Writes the given data to a Tempfile and adds it to the collection of temp files.
    def temp_data=(data)
      self.temp_path = write_to_temp_file data unless data.nil?
    end
    
    # Writes the given file to a randomly named Tempfile.
    def write_to_temp_file(data)
      self.class.write_to_temp_file data, self.filename
    end
    
    # Writes the given data to a new tempfile, returning the closed tempfile.
    def self.write_to_temp_file(data, filename)
      FileUtils.mkdir_p(self.tempfile_path)
      returning Tempfile.new(filename, self.tempfile_path) do |tmp|
        tmp.binmode
        tmp.write data
        tmp.close
      end
    end
    
    # Find all data records about a specified source    
    def self.find_data_records(id)
      find(:all, :conditions => ["source_record_id = ?", id])
    end
    
    def self.find_by_type_and_location!(source_data_type, location)
      # TODO: Should it directly instantiate the STI sub-class?
      # In this case we should use the following line instead.
      #
      # source_data = source_data_type.classify.constantize.find_by_location(location, :limit => 1)
      #
      source_data = self.find(:first, :conditions => ["type = ? AND location = ?", source_data_type.camelize, location])
      raise ActiveRecord::RecordNotFound if source_data.nil?
      source_data
    end
    
    # Return the class name associated to the given mime-type.
    # TODO: We should provide a kind of registration of subclasses,
    # because now associations are hardcoded.
    def self.mime_type(content_type)
      case Mime::Type.lookup(content_type).to_sym
        when :text:             'SimpleText'
        when :jpg, :jpeg, :gif,
          :png, :tiff, :bmp:    'ImageData'
        when :xml:              'XmlData'
        else name.demodulize
      end
    end
    
    private
    def save_attachment?
      !self.content_type.nil?
    end
    
    def assign_location
      self.location = filename
    end
    
    def assign_mime_type
      self.type = self.class.mime_type(content_type)
    end

    def full_filename
      @full_filename ||= File.join(self.class.data_path, self.type, self.filename)
    end

    def save_attachment
      FileUtils.mkdir_p(File.dirname(full_filename))
      File.cp(temp_path, full_filename)
      File.chmod(0644, full_filename)
    end
  end
end
