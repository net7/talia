# require 'objectproperties' # Includes the class methods for the object_properties
require 'local_store/source_record'
require 'local_store/data_record'
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
 
    def initialize(uri, *types)
      super(uri, *types)
      self.primary_source = false
    end
    # Used to add a new source to this macrcontribution.
    # The adding is done by just creating a new RDF triple.
    def add_source(new_source_uri)
      new_source = Source.new(new_source_uri)
      new_source[N::HYPER::isPartOfMacrocontribution] << self
      new_source.save!
    end
    
    def title=(title)
      self.predicate_set(:hyper, "title", title)
    end
    
    def editors_notes=(notes)
      self.predicate_set(:hyper, 'editorsNotes', notes)
    end
    
    def macrocontribution_type=(type)
      self.predicate_set(:hyper, "macrocontributionType", type)      
    end
    
    def title
      self.hyper::title
    end
    
    def editors_notes
      self.hyper::editorsNotes
    end
    
    def macrocontribution_type
      self.hyper::macrocontribution_type
    end
    
  end  
    
      
end
  
