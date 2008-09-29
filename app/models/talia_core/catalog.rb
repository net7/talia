module TaliaCore
  
  # A catalog is a collection of AbstractWorkCard records. 
  class Catalog < Source
    
    DEFAULT_CATALOG_NAME = N::LOCAL + 'system_default_catalog'
    
    # Returns all the elements, restricting the result to the given type
    # if one is given. The type should be a class.
    def elements(type = nil)
      type ||= Source
      raise(ArgumentError, "Type for elements should be a class") unless(type.is_a?(Class))
      type.find(:all, :find_through => [N::HYPER.in_catalog, self])
    end
    
    
    # Returns an array containing a list of all the elements of the given type 
    # (manuscripts, works, etc.). Types can also contain subtypes (notebook, draft, etc.) 
    # 
    # The types should be a list of N::URI elements indicating the RDF classes.
    def elements_by_type(*types)
      qry = Query.new(TaliaCore::ActiveSource).select(:element).distinct
      types.each do |type|
        qry.where(:element, N::RDF.type, type)
      end
      qry.where(:element, N::HYPER.in_catalog, self)
      qry.execute
    end
    
    # Creates a new concordant record for the given element and adds it 
    # to the catalog. This will also copy the properties of the given 
    # element.
    #
    # If no siglum is given, this will use the same siglum as the element given.
    # 
    # The URI of the new element will be <catalog_uri>/<siglum>
    #
    # Any block given will be run after the new element was completely created
    # but before it is saved, it will receive the new element as the only parameter.
    def add_from_concordant(concordant_element, children = false, new_siglum = nil)
      raise(ArgumentError, "Can only create concordant catalog elements from Cards, this was a #{concordant_element.class}: #{concordant_element.uri}") unless(concordant_element.is_a?(ExpressionCard))
      
      new_el = concordant_element.clone_concordant(concordant_uri_for(concordant_element, new_siglum), :catalog => self)
      
      yield(new_el) if(block_given?)
      
      new_el.save!
      if(children)
        for_children_of(concordant_element) do |child|
          add_from_concordant(child, true) do |child_clone|
            child_clone.hyper::part_of << new_el
          end
        end
      end
      
      assit_equal(new_el.concordance[N::HYPER.concordant_to].size, new_el.concordance.my_rdf[N::HYPER.concordant_to].size)
      new_el
    end
    
    # This creates the new uri that a concordant clone of the given element 
    # would have by default. The siglum (which will be part of the URI) may
    # be specified optionally.
    def concordant_uri_for(element, new_siglum = nil)
      siglum = new_siglum || element.siglum || element.uri.local_name
      self.uri + '/' + siglum
    end
    
    # This adds the element to this catalog. This disassociates the elements
    # from their previous catalog and does not modify their URIs.
    def add_card(element, children = false)
      raise(ArgumentError, "Can only add ExpressionCards") unless(element.is_a?(ExpressionCard))
      element.catalog = self
      
      if(children)
        for_children_of(element) { |child| add_card(child, true) }
      end
    end
    
    def title
      @title ||= self.hyper::title.last
    end
    
    def description
      @description ||= self.hyper::description.last
    end
    
    # Returns the default catalog that will be used if no other catalog is
    # specified
    def self.default_catalog
      catalog = Catalog.new(Catalog::DEFAULT_CATALOG_NAME)
      catalog.save! if(catalog.new_record?)
      catalog
    end
    
    # A descriptive text about this element
    def material_description
      description = inverse[N::HYPER.description_of]
      assit(description.size <= 1, "There shouldn't be multiple descriptions")
      (description.size > 0) ? description[0] : ''
    end
    
    protected
    
    
    # Goes through the children of the given element
    def for_children_of(element)
      children = Source.find(:all, :find_through => [N::HYPER.part_of, element]).uniq
      children.each { |child| yield(child) }
    end
    
  end
  
end
