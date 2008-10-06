require 'initializer'
require File.join('talia_core', 'data_types', 'file_store')


module TaliaCore
  module DataTypes
   
    # ActiveRecord interface to the data record in the database
    class DataRecord < ActiveRecord::Base
      
      
      belongs_to :source, :class_name => 'TaliaCore::Source'
    
      before_create :set_mime_type # Mime type must be saved before the record is written

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
   
      class << self

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

      end

      # Assign the STI subclass, perfoming a mime-type lookup.
      def assign_type(content_type)
        self.type = self.class.mime_type(content_type)
      end

      private
    
      # Returns demodulized type or class name.
      def class_name
        (self.type.to_s || self.class.name).demodulize
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