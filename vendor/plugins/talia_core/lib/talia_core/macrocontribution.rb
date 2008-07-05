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
 
    # Used to add a new source to this macrcontribution.
    # The adding is done by just creating a new RDF triple.
    def add_source(new_source_uri)
      new_source = Source.new(new_source_uri)
      new_source[N::HYPER::isPartOfMacrocontribution] << self
      new_source.save!
    end
    
    # returns an array containing a list of the book types available and connected to this facsimile edition
    # (e.g.: 'Works', 'Manuscripts', ...)
    # 
    def related_types
      #TODO: everything
      result = ['works', 'manuscripts', 'library', 'correspondence', 'picture']
    end
    
    # returns an array containing a list of available subtypes of the given type. Of course they must
    # be present in the facsimile edition we're in
    def related_subtypes(type)
      #TODO: everything
      result = ['copybooks', 'notebooks', 'drafts']
    end
    
    # returns an array containing a list of all the books of the given type (manuscripts, works, etc.) 
    # and subtype (notebook, draft, etc.) belonging to this Facsimile Edition
    def related_primary_sources(type, subtype)
      #TODO: everything
      result = ['N-IV-1', 'N-IV-2', 'N-IV-3', 'N-IV-4']
    end
    
    # returns all the pages of the given book contained in this Facsimile Edition 
    def related_pages(book)
      #TODO: everything
      result =  ['N-IV-2,1','N-IV-2,2','N-IV-2,3', 'N-IV-2,4']
    end
    # returns the description of the book given as parameter, taken from the "material description" contribution
    # which is supposed to be related to this Facsimile Edition
    def material_description(book)
      #TODO: everything
      result = "#{book} description"
    end
    
    # returns the URL of the small version of the image related to the given source.
    # please note that, usually, source_uri is the uri of a book or page, while the image is 
    # to be found in the facsimile related to it
    # 
    # special case: if source_uri is a book, the image should be taken from the facsimile 
    # of the first page of that book (that also belong to the Macrocontribution)
    
    def small_image_url(source_uri)
      #TODO: everything
    end
  end  
    
      
end
  
