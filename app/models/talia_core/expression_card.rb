module TaliaCore
  
  # An Expression is an element from the FRBR schema (see
  # http://www.ifla.org/VII/s13/frbr/frbr1.htm#3.2). 
  # 
  # Each Expression is a the general realization of an intellectual or 
  # artistic concept. For example an "Expression" would be one edition of 
  # a particular book written by a philosopher. We'll also have sub-parts
  # (e.g. pages, chapter) that are also treated in the same way.)
  # 
  # In this system each Expression is represented by one or more 
  # "Expression Cards". A card is akin to a catalog card, it contains the
  # name/siglum of the element and a set of metadata (the metadata referring
  # to the element itself, _not_ the card) 
  # 
  # Two cards are called "concordant" if they refer to the same Expression 
  # (e.g. the same page in the same book)
  # 
  # Each card can contain on ore more "Manifestations". The manifestations are
  # the actual data related to that Expression. The are always unique and never
  # concordant. Concordant cards should usually have the same Manifestations.
  #
  # An expression card is *always* part of *exactly* one catalog, even if it's
  # just the default catalog.
  class ExpressionCard
    
    # The siglum of this element in the current catalog
    def siglum
      # TODO: Implementation
    end
    
    # Get the concordance record for this card. This will return the
    # concordance itself, so that the metadata of the concordance record
    # can be inspected.
    def concordance
      # TODO: Implementation
    end
    
    # Get the cards that are concordant to this one
    def concordant_cards
      # TODO: Implementation
    end
    
    # The catalog that this card belongs to
    def catalog
      # TODO: Implementation
    end
    
    # Assign a catalog to the card
    def catalog=(new_catalog)
      # TODO: Implementation
    end
    
    # This returns the manifestations FIXME of this card. You may restrict
    # this to a given type (e.g. "Facsimile")
    def manifestations(type = nil)
      # TODO: Implementation + Name
    end
    
  end
end
