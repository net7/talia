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
  end
end