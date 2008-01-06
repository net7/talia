require 'semantic_naming'
require 'active_record'

# Module to add support for a uri field in ActiveRecords that uses
# the semantic_naming module
module ActiveRecord
  class Base
    
    # Adds the uri getter an setter to the current
    # class
    def self.has_uri_field(uri_type)
      assit_type(uri_type, Class)
      
      # For the URIs we do a minimal check (String with no blanks and : char somewher)
      validates_format_of :uri, :with => /\A\S*:\S*\Z/
      validates_uniqueness_of :uri
      
      # Initializer takes the uri field
      define_method("initialize") do |uri|
        super(nil)
        write_attribute(:uri, uri.to_s)
      end
      
      # Return the URI as an URI object
      define_method("uri") do
        uri_type.new(read_attribute(:uri))
      end
      
      # Set the URI
      define_method("uri=") do |value|
        write_attribute(:uri, value.to_s)
      end
      
      # The array-type reader
      define_method("[]") do |attr|
        if(attr.to_sym == :uri)
          uri_type.new(read_attribute(:uri))
        else
          super
        end
      end
      
      # The array-type writer
      define_method("[]=") do |attr, value|
        if(attr.to_sym == :uri)
          write_attribute(:uri, value.to_s)
        else
          super
        end
      end
      
    end
  end
end
