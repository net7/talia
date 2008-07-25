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
  class ExpressionCard < Source
    
    # The siglum of this element in the current catalog
    def siglum
      siglum = predicate(:hyper, :siglum)
      assit_equal(siglum.size, 1, "There should only exactly one siglum")
      (siglum.size > 0) ? siglum[0] : uri.local_name
    end
    
    # Get the concordance record for this card. This will return the
    # concordance itself, so that the metadata of the concordance record
    # can be inspected.
    def concordance
      # TODO: Implementation
    end
    
    # Get the cards that are concordant to this one. This includes the current
    # card itself.
    def concordant_cards
      # TODO: Implementation
    end
    
    # The catalog that this card belongs to
    def catalog
      catalog = predicate(:hyper, :in_catalog)
      assit_equal(catalog.size, 1, "The element must have exactly one catalog.")
      (catalog.size > 0) ? catalog[0] : nil
    end
    
    # Assign a catalog to the card
    def catalog=(new_catalog)
      raise(ArgumentError, "Must pass in existing catalog object") unless(new_catalog.is_a?(Catalog))
      predicate(:hyper, :in_catalog).remove
      predicate_set(:hyper, :in_catalog, new_catalog)
    end
    
    # This returns the manifestations of this card. 
    def manifestations
      type ||= Source
      raise(ArgumentError, "Manifestation type should be a class") unless(type.is_a?(Class))
      type.find(:all, :find_through_inv => [N::HYPER.manifestation_of, self])
    end
    
    # Allows to add a manifestation
    def add_manifestation(manifestation)
      raise(ArgumentError, "Only manifestations can be added here") unless(manifestation.is_a?(Manifestation))
      manifestation.predicate_set_uniq(:hyper, :manifestation_of, self)
    end
    
  end
end
