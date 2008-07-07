module TaliaCore 
  class FacsimileEdition < MacroContribution
    def initialize(uri, *types)
      super(uri, *types)
      # TODO: 'Facsimile' should actually be a valid value in the ontology
      self.macrocontribution_type = 'Facsimile'
    end
    
    # returns an array containing a list of the book types available and connected to this facsimile edition
    # (e.g.: 'Works', 'Manuscripts', ...)
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
    
    # returns the left or right "neighbour" source of the given source.
    # movement is expected in the form of "next" or "previous"
    def neighbour_source(source, movement)
      #TODO: everything
    end

  end
end