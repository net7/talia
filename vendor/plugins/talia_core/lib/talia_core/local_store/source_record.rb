require 'active_record'
require 'talia_core/local_store/has_uri_field'
require 'talia_core/local_store/dirty_relation_record'
require 'talia_core/local_store/type_record'

module TaliaCore
  
  # ActiveRecord interface to the source record in the database
  class SourceRecord < ActiveRecord::Base
     # Contains the "dirty relations" that are
    has_many :dirty_relation_records, :foreign_key => "source_record_id", :dependent => :destroy
    has_many :type_records, :foreign_key => "source_record_id", :dependent => :destroy
    has_many :data_records, :foreign_key => "source_record_id", :dependent => :destroy
    # Add the URI functionality
    has_uri_field N::URI
    
    # Validation
    validates_numericality_of :workflow_state
    
    # Custom validation
    def validate
      errors.add(:primary_source, "cannot be nil") if(self[:primary_source] == nil)
    end
    
    # Helper to get a record with the given URI, or the given multiple uris
    # This raises an error if the record does not exist
    #
    # The method returns a single record, or an Array of records if multiple 
    def self.find_by_uri(*uris)
      raise(ActiveRecord::RecordNotFound, "Cannot find record without URI") unless(uris.size > 0)
      
      if(uris.size == 1)
        if(uris[0].is_a?(Array))
          # Retrieve one element or multiple, depending on the array size
          (uris[0].size == 1) ? find_by_one_uri(uris[0][0]) : find_by_some_uris(uris[0])
        else
          find_by_one_uri(uris[0]) # Find just a single record
        end
      else
        find_by_some_uris(uris) # Find multiple uris
      end
    end
    
    # Helper that accepts a hash with query options of the Source class
    # and executes the database query.
    #
    # The scope can be :all or :first, as usual.
    def self.find_by_hash(scope, option_hash)
      assit_type(option_hash, Hash)
      
      db_hash = Hash.new
      
      db_hash[:limit] = option_hash.delete(:limit) if(option_hash[:limit])
      db_hash[:offset] = options_hash.delete(:offset) if(option_hash[:offset])
      db_hash[:conditions] = sanitize_sql_hash(option_hash)
      
      find(scope, db_hash)
    end
    
    # Helper to see if a record with the given uri exists
    def self.exists_uri?(uri)
      find(:first, :conditions => ['uri = ?', uri.to_s]) != nil
    end
    
    # Opens the sanitize method from ActiveRecord::Base
    def self.sanitize_sql(condition)
      super(condition)
    end
    
    protected
    
    # Find a single record by using one uri
    def self.find_by_one_uri(uri)
      source_record = find(:first, :conditions => ['uri = ?', uri.to_s])
      raise(ActiveRecord::RecordNotFound, "Not in system: " + uri.to_s) unless(source_record)
      
      source_record
    end
    
    # Find multiple records from multiple uris
    def self.find_by_some_uris(uris)
      assit_type(uris, Array)
      raise RecordNotFound("Cannot find record without URI")  unless(uris.size > 0)
      # Find it
      result = find(:all, :conditions => sanitize_sql_hash({:uri => uris}))
      
      raise(ActiveRecord::RecordNotFound, "One or more SourceRecords not found") unless(uris.size == result.size)
    
      result
    end
    
  end
end