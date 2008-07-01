# require 'objectproperties' # Includes the class methods for the object_properties
require 'local_store/source_record'
require 'local_store/data_record'
require 'local_store/macrocontribution_record'
require 'local_store/workflow/workflow_record'
require 'pagination/source_pagination'
require 'query/source_query'
require 'active_rdf'
require 'semantic_naming'
require 'dummy_handler'
require 'rdf_resource'
require 'type_list'

module TaliaCore
  
  # This represents a macrocontribution.
  #
  # Everything valid for a normal source is also valid here
  #
  # It offers some methods for dealing with Macrocontributions  
  class Macrocontribution < Source
  end  
    
      
end
  
