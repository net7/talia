require 'active_record'
require 'talia_core/data_types/data_types_loader'

module TaliaCore

  # ActiveRecord interface to the data record in the database
  class DataRecord < ActiveRecord::Base
    
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
    
    # Find all data records about a specified source    
    def self.find_data_records(id)
      find(:all, :conditions => "source_record_id = #{id}")
    end
    
    def self.find_by_type_and_location!(source_data_type, location)
      source_data = self.find(:first, :conditions => ["type = ? AND location = ?", source_data_type.camelize, location])
      raise ActiveRecord::RecordNotFound if source_data.nil?
      source_data
    end
  end
end