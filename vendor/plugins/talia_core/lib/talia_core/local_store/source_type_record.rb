module TaliaCore
  require 'active_record'
  require 'talia_core/local_store/has_uri_field'
  
  # ActiveRecord interface to a list of type uris for each sources
  class SourceTypeRecord < ActiveRecord::Base
    
    has_uri_field N::SourceClass
    
  end
end