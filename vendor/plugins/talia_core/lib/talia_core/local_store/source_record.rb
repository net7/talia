module TaliaCore
  require 'active_record'
  require 'talia_core/local_store/srecord_type'
  require 'talia_core/local_store/srecord_dirty_relation'
  
  # ActiveRecord interface to the source record in the database
  class SourceRecord < ActiveRecord::Base
    has_many :types, :class_name => "TaliaCore::SrecordType", :foreign_key => "source_record_id"
    has_many :dirty_relations, :class_name => "TaliaCore::SrecordDirtyRelations", :foreign_key => "source_record_id"
    
    def initialize(uri)
      super(nil)
      @uri = uri.to_s
    end
    
    # Return the URI as an URI object
    def uri
      N::URI.new(@uri)
    end
    
    # Set the URI
    def uri=(uri)
      @uri = uri.to_s
    end
    
    # Helper to get a record with the given URI
    # This raises an error if the record does not exist
    def self.find_by_uri(uri)
      source_record = find(:first, :conditions => "uri = \"#{uri.to_s}\"")
      raise(ActiveRecord::RecordNotFound, "Not in system: " + uri) unless(source_record)
      
      source_record
    end
    
    # Helper to see if a record with the given uri exists
    def self.exists_uri?(uri)
      find(:first, :conditions => "uri = \"#{uri.to_s}\"") != nil
    end
    
  end
end