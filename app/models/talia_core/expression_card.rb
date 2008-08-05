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
    
    singular_property :siglum, N::HYPER.siglum
    singular_property :catalog, N::HYPER.in_catalog
    singular_property :title, N::DCNS.title
    
    before_create :set_default_catalog
    
        # Returns the properties that should be cloned when creating a new concordant
    # clone
    class_inheritable_accessor :props_to_clone_var
    def self.props_to_clone
      self.props_to_clone_var ||= []
      self.props_to_clone_var
    end
    
    # The inverse properties to clone
    class_inheritable_accessor :inverse_props_to_clone_var
    def self.inverse_props_to_clone
      self.inverse_props_to_clone_var ||= []
      self.inverse_props_to_clone_var
    end
    
    # Cloned properties are defined at the END OF THIS FILE!
    
    # Get the concordance record for this card. This will return the
    # concordance itself, so that the metadata of the concordance record
    # can be inspected.
    def concordance
      concs = Concordance.find(:all, :find_through => [N::HYPER.concordant_to, self])
      assit(concs.size <= 1, "Should not have more than 1 concordance object")
      concs.size > 0 ? concs[0] : nil
    end
    
    # Get the cards that are concordant to this one. This includes the current
    # card itself.
    def concordant_cards(catalog = nil)
      return [] unless(concordance)
      concordance.concordant_cards(catalog)
    end
    
    # Clone the current card and make the new one concordant to the current
    # one
    def clone_concordant(uri)
      new_el = clone(uri)
      make_concordant(new_el)
      new_el
    end
    
    # Clones the current card, with the properties and inverse properties that
    # are configured for cloning.
    def clone(uri)
      new_el = self.class.new(uri)
      self.class.props_to_clone.each { |p| new_el[p] << self[p] }
      self.class.inverse_props_to_clone.each do |p|
        self.inverse[p].each { |targ| targ[p] << new_el }
      end
      new_el
    end
    
    # Make the given card concordant to this one. Creating a new concordance
    # saves the sources.
    def make_concordant(c_card)
      raise(ArgumentError, "Concordant element must be a card") unless(c_card.is_a?(ExpressionCard))
      if(concordance && c_card.concordance)
        # There are two concordances, merge them
        concordance.merge(c_card.concordance)
      elsif(concordance)
        concordance.add_card(c_card) # concordance is on this, add the other card
      elsif(c_card.concordance)
        c_card.concordance.add_card(self) # c. is on the other, add this
      else
        # No concordance, create one. We'll try to make a unique URL for this,
        # using a hash of the current URL
        conc = Concordance.new(N::LOCAL + 'concordance_' + Digest::MD5.new.hexdigest(uri.to_s))
        conc.add_card(self)
        conc.add_card(c_card)
        conc.save!
      end
    end
    
    # This returns the manifestations of this card. You can give an optional
    # type which must be a class.
    def manifestations(type = nil)
      type ||= Source
      raise(ArgumentError, "Manifestation type should be a class") unless(type.is_a?(Class))
      type.find(:all, :find_through => [N::HYPER.manifestation_of, self])
    end
    
    # Allows to add a manifestation
    def add_manifestation(manifestation)
       raise(ArgumentError, "Only manifestations can be added here") unless(manifestation.is_a?(Manifestation))
      manifestation.predicate_set_uniq(:hyper, :manifestation_of, self)
    end
    
    protected
    
    # Assign the default catalog
    def set_default_catalog
      self.catalog = Catalog.default_catalog unless(self.catalog)
    end
    
    # Helper to to register the properties that should be cloned
    def self.clone_properties(*props)
      props.each { |p| props_to_clone << p }
    end
    
    # Helper to register inverse properties that should be cloned
    def self.clone_inv_properties(*props)
      props.each { |p| inverse_props_to_clone << p }
    end
    
    clone_properties N::RDF.type,
      N::HYPER.type,
      N::HYPER.subtype,
      N::HYPER.siglum
    
  end
end
