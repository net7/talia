require 'uri'

module TaliaCore
  
  # A keyword that can be assigned to Sources. Each Source can have any number
  # of keywords. The keyword will be part of the URI.
  class Keyword < Source
    
    singular_property :keyword_value, N::HYPER.keyword_value
    
    
    # Returns all sources tagged with that keyword. Optionally limit this
    # to the given Source class
    def tagged_sources(source_class = nil)      
      source_class ||= ActiveSource
      source_class.find(:all, :find_through => [N::HYPER.keyword, self])
    end
    
    # Checks if a source for the given keyword exists
    def self.exists_with_keyword?(value)
      exists?(uri_for(value))
    end
    
    # Find a keyword by the given keyword string
    def self.find_by_keyword(value)
      find(uri_for(value))
    end
    
    # Creates a new keyword from the given string. Returns an existing object
    # if it is found in the db. This will automatically save the new record 
    # (there shouldn't be a need to save keyword objects in any other place).
    def self.get_with_key_value!(value)
      my_uri = uri_for(value)
      return find(my_uri) if(exists?(my_uri))
      
      new_kw = self.new(my_uri)
      new_kw.keyword_value = value
      new_kw.save!
      new_kw
    end
    
    # The name prefix that is used for the keyword URI's
    def self.uri_prefix
      @uri_prefix ||= N::LOCAL + 'keywords/'
    end
    
    # Gets the uri for the given keyword
    def self.uri_for(keyword)
      uri_prefix + UriEncoder.normalize_uri(keyword)
    end

    def self.find_all_by_recurrences
      self.find_by_sql "SELECT a.id, COUNT(*) AS count, a.uri FROM semantic_relations s, active_sources a WHERE s.object_id = a.id and a.type = 'Keyword' GROUP BY object_id ORDER BY a.uri ASC;"
    end

    private 
    
    def validate
      errors.add("URI #{self.uri} doesn't match value #{self.keyword_value}") if(self.uri != self.class.uri_for(self.keyword_value))
    end
    
  end
  
end
