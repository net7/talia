require 'initializer'
require 'ftools'
require File.join('talia_core', 'data_types', 'file_store')


module TaliaCore
  module DataTypes
   
    # ActiveRecord interface to the data record in the database
    class DataRecord < ActiveRecord::Base
      include FileStore
      belongs_to :source, :class_name => 'TaliaCore::Source'
    
      before_create :set_mime_type # Mime type must be saved before the record is written
      after_save :save_attachment
      after_create :write_file_after_save # TODO: Is this really only for create operations
   
      before_destroy :destroy_attachment

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
      
      def extract_mime_type(location)
        'text'
      end
    
      # class methods ============================================
    
      # TODO: return the data checksum 
      def checksum
      end

      # TODO: an iterator that calls a block on each byte in the object
      def each_byte
      end
      
      def mime_type
        self.mime
      end
    
      attr_accessor :temp_path    
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
    
      # Copies the given file to a randomly named Tempfile.
      def copy_to_temp_file(file)
        self.class.copy_to_temp_file file, random_tempfile_filename
      end
    
      # Writes the given file to a randomly named Tempfile.
      def write_to_temp_file(data)
        self.class.write_to_temp_file data, self.location
      end
    
      class << self
        # Path used to store temporary files.
        def tempfile_path
          @@tempfile_path ||= File.join(TALIA_ROOT, 'tmp', 'data_records')
        end

        # Path used to store data files.
        def data_path
          @@data_path ||= File.join(TALIA_ROOT, 'data')
        end

        # Copies the given file path to a new tempfile, returning the closed tempfile.
        def copy_to_temp_file(file, temp_base_name)
          create_tempfile_path
          returning Tempfile.new(temp_base_name, self.tempfile_path) do |tmp|
            tmp.close
            FileUtils.cp file, tmp.path
          end
        end

        # Writes the given data to a new tempfile, returning the closed tempfile.
        def write_to_temp_file(data, filename)
          create_tempfile_path
          returning Tempfile.new(filename, self.tempfile_path) do |tmp|
            tmp.binmode
            tmp.write data
            tmp.close
          end
        end

        # Find all data records about a specified source    
        def find_data_records(id)
          find(:all, :conditions => { :source_id => id })
        end

        def find_by_type_and_location!(source_data_type, location)
          # TODO: Should it directly instantiate the STI sub-class?
          # In this case we should use the following line instead.
          #
          # source_data = source_data_type.classify.constantize.find_by_location(location, :limit => 1)
          #
          source_data = self.find(:first, :conditions => ["type = ? AND location = ?", source_data_type.camelize, location])
          raise ActiveRecord::RecordNotFound if source_data.nil?
          source_data
        end

        # Find or create a record for the given location and source_id, then it saves the given file.
        def find_or_create_and_assign_file(params)
          data_record = self.find_or_create_by_location_and_source_id(extract_filename(params[:file]), params[:source_id])
          data_record.file = params[:file]
          data_record.save # force attachment save and it also saves type attribute.
        end

        # Return the class name associated to the given mime-type.
        # TODO: We should provide a kind of registration of subclasses,
        # because now associations are hardcoded.
        def mime_type(content_type)
          case Mime::Type.lookup(content_type).to_sym
          when :text:             'SimpleText'
          when :jpg, :jpeg, :gif,
              :png, :tiff, :bmp:    'ImageData'
          when :xml:              'XmlData'
          when :pdf:              'PdfData'
          else name.demodulize
          end
        end
      
        # Extract the filename.
        def extract_filename(file_data)
          file_data.original_filename if file_data.respond_to?(:original_filename)
        end
      
        def create_tempfile_path
          FileUtils.mkdir_p(tempfile_path) unless File.exists?(tempfile_path)
        end
      end

      # Assign the STI subclass, perfoming a mime-type lookup.
      def assign_type(content_type)
        self.type = self.class.mime_type(content_type)
      end

      private
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

      # Return the full path of the current attachment.
      def full_filename
        @full_filename ||= self.get_file_path #File.join(data_path, class_name, location)
      end

      # Save the attachment on the data_path directory.
      def save_file
        FileUtils.mkdir_p(File.dirname(full_filename))
        File.cp(temp_path, full_filename)
        File.chmod(0644, full_filename)
      end
    
      # Extract the filename.
      # This is a wrapper for the extract_filename class method.
      def extract_filename(file_data)
        self.class.extract_filename(file_data)
      end
    
      # Path used to store temporary files.
      # This is a wrapper for the tempfile_path class method.
      def tempfile_path
        self.class.tempfile_path
      end
    
      # Path used to store data files.
      # This is a wrapper for the data_path class method.
      def data_path
        self.class.data_path
      end
    
      # Returns demodulized type or class name.
      def class_name
        (self.type.to_s || self.class.name).demodulize
      end
    
      # Generates a unique filename for a Tempfile. 
      def random_tempfile_filename
        "#{rand Time.now.to_i}#{location || 'attachment'}"
      end
      
      # set mime type 
      def set_mime_type
        assit_not_nil(self.location, "Location for #{self} should not be nil")
        if !self.location.nil?
          # Set mime type for the record
          self.mime = extract_mime_type(self.location)
          assit_not_nil(self.mime, "Mime should not be nil (location was #{self.location})!")
        end
      end
      
    end
  end
end