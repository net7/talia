=begin
This file defines the class methods for the Source class which allow
the definition of "object properties" which are owned by the source
object itself (instead of the RDF) 
=end
module TaliaCore
  class Source
    
    # This creates a reader and writer for the given property.
    # Both calls are passed on to the @object_store
    # See the main Source class definition for a description
    # of the @object_store
    # The id parameter contains a symbol representing the 
    # method to be defined
    def self.object_property(id)
      module_eval <<-"end_eval"
        # Passes the "read" call to the object store
        def #{id.id2name}
          @source_record.#{id.id2name}
        end
        
        # Passes the "write" call to the object store
        def #{id.id2name}=(property)
          @source_record.#{id.id2name} = property
        end
      end_eval
    end
  end
end