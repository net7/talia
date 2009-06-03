module TaliaCore
  
  # A catalog is a collection of ExpressionCard records. 
  class Catalog < Source
    
    singular_property :material_description, N::HYPER.material_description
    singular_property :siglum, N::HYPER.siglum
    singular_property :position, N::HYPER.position
    
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
    #
    # It's possible to pass either a single, type, a list of types and also
    # an optional array of options.
    #
    #  * :sort - if set to true, will sort the result on the "position" property.
    #     elements that have that property will be completely ignored.
    #
    # ==Examples==
    #
    #   > elements_by_type(N::TALIA.Book)
    #   > elements_by_type(N::TALIA.Book, :sort => true)
    def elements_by_type(*args)
      # Setup the options from the arguments
      options = {}
      options = args.pop if(args.last.kind_of?(Hash))
      types = args

      qry = Query.new(TaliaCore::ActiveSource).select(:element).distinct
      types.each do |type|
        qry.where(:element, N::RDF.type, type)
        if(options[:sort])
          qry.where(:element, N::HYPER.position, :position)
          qry.sort(:position)
        end
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

      # TODO: Maybe add a dirty check after passing to Rails 2.3?
      save! if(new_record?) # Cloning only works on properly saved things...

      new_el = concordant_element.clone_concordant(concordant_uri_for(concordant_element, new_siglum), :catalog => self)
      
      yield(new_el) if(block_given?)
      
      new_el.save!
      if(children)
        for_children_of(concordant_element) do |child|
          add_from_concordant(child, true) do |child_clone|
            child_clone.write_predicate_direct(N::DCT.isPartOf, new_el)
          end
        end
      end
      
      # assit_equal(new_el.concordance[N::HYPER.concordant_to].size, new_el.concordance.my_rdf[N::HYPER.concordant_to].size)
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
      # Deprecate this - having an object on an object that doesn't modify the
      # object but the parameter is not a good practice
      warn "[DEPRECATED] #add_card is deprecated and will be removed"
      raise(ArgumentError, "Can only add ExpressionCards") unless(element.is_a?(ExpressionCard))
      element.catalog = self

      element.save!

      if(children)
        for_children_of(element) { |child| add_card(child, true) }
      end

    end
    
    def title
      @title ||= self.hyper::title.last
    end
    
    # Returns the default catalog that will be used if no other catalog is
    # specified
    def self.default_catalog
      catalog = Catalog.new(Catalog::DEFAULT_CATALOG_NAME)
      catalog.save! if(catalog.new_record?)
      catalog
    end
    
    protected
    
    
    # Goes through the children of the given element
    def for_children_of(element)
      children = Source.find(:all, :find_through => [N::DCT.isPartOf, element], :readonly => false).uniq
      children.each { |child| yield(child) }
    end
    
  end
  
end
