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
    singular_property :material_description, N::HYPER.material_description
    singular_property :category, N::HYPER.category
    singular_property :series, N::HYPER.series
    
    before_create :set_default_catalog
    before_save :clear_concordance

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
    
    # Callbacks for the clone method
    class_inheritable_accessor :clone_callbacks
    
    # Get the concordance record for this card. This will return the
    # concordance itself, so that the metadata of the concordance record
    # can be inspected.
    def concordance
      concs = Concordance.find(:all, :find_through => [N::HYPER.concordant_to, self], :readonly => false)
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
    def clone_concordant(uri, options = {})
      new_el = nil
      new_el = clone(uri, options)
      make_concordant(new_el)
      new_el
    end
    
    # Clones the current card, with the properties and inverse properties that
    # are configured for cloning. The options hash will be passed to the 
    # callback(s). Then only option that is recognized by the clone
    # method itself is :catalog, which sets the clone's catalog.
    def clone(uri, options = {})
      raise(ArgumentError, "Element cannot be cloned #{self.uri} - target already exists #{uri}") if(ActiveSource.exists?(uri))
      raise(ArgumentError, "Target element already exists #{uri}") if(ActiveSource.exists?(uri))
      new_el = self.class.new(uri)
      new_el = clone_properties_to(new_el, options)
    rescue Exception => e
      message = e.message + " (raise during clone of #{self.uri})"
      new_err = e.class.new(message)
      new_err.set_backtrace(e.backtrace)
      raise new_err
    end
    

    # Make the given card concordant to this one. Creating a new concordance
    # saves the sources.
    def make_concordant(c_card)
      raise(ArgumentError, "Concordant element must be a card") unless(c_card.is_a?(ExpressionCard))
      autosave = c_card.autosave_rdf?
      c_card.autosave_rdf = false # There won't be anything added to it
      if(concordance && c_card.concordance)
        # There are two concordances, merge them
        concordance.merge(c_card.concordance)
        concordance.save!
      elsif(concordance)
        concordance.add_card_direct!(c_card)# concordance is on this, add the other card
      elsif(c_card.concordance)
        c_card.concordance.add_card_direct!(self) # c. is on the other, add this
      else
        # No concordance, create one. We'll try to make a unique URL for this,
        # using a hash of the current URL
        conc = Concordance.new(N::LOCAL + 'concordance_' + Digest::MD5.new.hexdigest(uri.to_s))
        conc.add_card_direct!(self)
        conc.add_card_direct!(c_card)
      end
      c_card.autosave_rdf = autosave
    end
    
    # This returns the manifestations of this card. You can give an optional
    # type which must be a class or an URI.
    def manifestations(type = nil)
      raise(ArgumentError, "Manifestation type should be a Class or an URI") unless(type.is_a?(N::URI) or type.is_a?(Class) or type.nil?)
      qry = Query.new(TaliaCore::Source).select(:m).distinct
      qry.where(:m, N::HYPER.manifestation_of, self)
      case type
      when Class
        qry.where(:m, N::RDF.type, (N::TALIA + type.name.demodulize))
      when N::URI
        qry.where(:m, N::RDF.type, (type))
      end
      qry.execute
    end
    
    # Allows to add a manifestation (the manifestation will be auto-saved
    def add_manifestation(manifestation)
      raise(ArgumentError, "Only manifestations can be added here") unless(manifestation.is_a?(Manifestation))
      manifestation.predicate_set_uniq(:hyper, :manifestation_of, self)
      manifestation.save!
      manifestation
    end
    
    # returns all the subpart of this expression card
    def subparts
    end
    
    # returns all the subpart of this expression card that have some manifestations 
    # of the given type related to them. Manifestation_type must be an URI
    def subparts_with_manifestations(manifestation_type, subpart_type = nil)
      assit(false, 'Not Implemented')
    end
    
    # Add a keyword from a keyword string. If necessary the keyword object
    # will be created.
    def add_keyword(keyword)
      kw_object = Keyword.get_with_key_value!(keyword)
      self[N::HYPER.keyword] << kw_object
    end
    
    # Returns all keywords (as an array of strings)
    def keywords_as_strings
      self[N::HYPER.keyword].collect { |kw| kw.keyword_value }
    end
    
    # Returns all keywords (as an array of objects)
    def keywords
      self[N::HYPER.keyword]
    end
    

    # Copies the "cloneable" properties of this source to the given target
    # source. The options may specify a catalog to which the new source
    # will be added.
    def clone_properties_to(clone, options={})
      cp_properties(clone)
      cp_inverse_properties(clone)
      # Execute the callback methods.
      if(self.clone_callbacks)
        self.clone_callbacks.each { |cb| self.send(cb, clone, options) }
      end
      clone.catalog = options[:catalog] if(options[:catalog])
      clone
    end
  
    protected

    # Copy a property from the original source to the target. This contains
    # some checks to make sure that no duplicate types are created on the target
    def cp_properties(target)
      rels = self.semantic_relations.find(:all, :select => '*',
        :joins => self.class.props_join,
        :conditions => { :predicate_uri => self.class.props_to_clone })

      types_tmp = nil

      rels.each do |rel|
        if(rel.predicate_uri == N::RDF.type.to_s)
          types_tmp ||= target[N::RDF.type]
          cp_relation(rel, target) unless(types_tmp.detect{ |t| t.uri == rel.object.uri })
        else
          cp_relation(rel, target)
        end
      end
    end

    # Copies the inverse properties
    def cp_inverse_properties(target)
      rels = SemanticRelation.find(:all,
        :conditions => {
          :object_type => 'TaliaCore::ActiveSource',
          :object_id => self.id,
          :predicate_uri => self.class.inverse_props_to_clone
        })
      rels.each do |rel|
        subject = rel.subject
        subject[rel.predicate_uri] << target
        subject.save!
      end
    end

    # Copies the values of the given
    def cp_relation(rel, target)
      if(rel.object_type == 'TaliaCore::SemanticProperty')
        target[rel.predicate_uri] << rel.value
      else
        rel = SemanticRelation.new(:predicate_uri => rel.predicate_uri,
          :object_type => rel.object_type, :object_id => rel.object_id,
          :subject_id => target.id)
        rel_item = SemanticCollectionItem.new(rel, :plain)
        target[rel.predicate_uri].send(:insert_item, rel_item)
      end
    end
    
    # Adds a new callback. Callback methods must accept two parameters:
    # The new element and an options array. (The original element is self)
    def self.on_clone(callback_method)
      self.clone_callbacks ||= []
      self.clone_callbacks << callback_method.to_sym
    end
    
    # Assign the default catalog
    def set_default_catalog
      self.catalog = Catalog.default_catalog unless(self.catalog)
    end
    
    def clear_concordance
      @concordance = nil
    end


    # Helper to to register the properties that should be cloned
    def self.clone_properties(*props)
      props.each { |p| props_to_clone << p }
    end
    
    # Helper to register inverse properties that should be cloned
    def self.clone_inv_properties(*props)
      props.each { |p| inverse_props_to_clone << p }
    end
    
    # Standard properties to clone for all cards
    clone_properties N::RDF.type,
      N::HYPER.type,
      N::HYPER.subtype,
      N::HYPER.siglum,
      N::HYPER.position,
      N::HYPER.position_name,
      N::HYPER.category,
      N::HYPER.keyword,
      # series not cloned since the series object itself may need to be cloned
    N::HYPER.publication_place,
      N::HYPER.name,
      # Dublin Core properties
    N::DCNS.title,
      N::DCNS.description,
      N::DCNS.date,
      N::DCNS.publisher,
      N::DCNS.rights
    
    clone_inv_properties N::HYPER.manifestation_of
  end
end
