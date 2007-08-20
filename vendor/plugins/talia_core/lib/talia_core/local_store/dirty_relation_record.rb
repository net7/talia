module TaliaCore
  require 'active_record'
  require 'talia_core/local_store/has_uri_field'
  
  # ActiveRecord interface to a list of 
  class DirtyRelationRecord < ActiveRecord::Base
    
    has_uri_field N::URI
    
  end
end