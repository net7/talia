module TaliaCore
  require 'active_record'
  
  # ActiveRecord interface to a list of type uris for each sources
  class SrecordType < ActiveRecord::Base
    
    # Creates a new type object
    def initialize(uri)
      super
      @type_uri = uri.to_s
    end
    
  end
end