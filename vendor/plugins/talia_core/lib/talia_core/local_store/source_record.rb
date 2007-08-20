module TaliaCore
  require 'active_record'
  require 'talia_core/local_store/has_uri_field'
  require 'talia_core/local_store/source_type_record'
  require 'talia_core/local_store/dirty_relation_record'
  
  # ActiveRecord interface to the source record in the database
  class SourceRecord < ActiveRecord::Base
    has_many :source_type_records, :foreign_key => "source_record_id"
    # Contains the "dirty relations" that are
    has_many :dirty_relation_records, :foreign_key => "source_record_id"
    
    # Add the URI functionality
    has_uri_field N::URI
    
    # Validation
    validates_numericality_of :workflow_state
    
    # Custom validation
    def validate
      errors.add(:primary_source, "cannot be nil") if(self[:primary_source] == nil)
    end
    
    # Helper to get a record with the given URI
    # This raises an error if the record does not exist
    def self.find_by_uri(uri)
      source_record = find(:first, :conditions => ['uri = ?', uri.to_s])
      raise(ActiveRecord::RecordNotFound, "Not in system: " + uri.to_s) unless(source_record)
      
      source_record
    end
    
    # Helper to see if a record with the given uri exists
    def self.exists_uri?(uri)
      find(:first, :conditions => ['uri = ?', uri.to_s]) != nil
    end
    
  end
end