module TaliaCore
  
  # A catalog is a collection of AbstractWorkCard records. 
  class Catalog < Source
    
    # Returns all the elements, restricting the result to the given type
    # if one is given. The type should be a class.
    def elements(type = nil)
      type ||= Source
      raise(ArgumentError, "Type for elements should be a class") unless(type.is_a?(Class))
      type.find(:all, :find_through => [N::HYPER.in_catalog, self])
    end
    
    # Creates a new concordant record for the given element and adds it 
    # to the catalog. This will also copy the properties of the given 
    # element.
    #
    # If no siglum is given, this will use the same siglum as the element given.
    # 
    # The URI of the new element will be <catalog_uri>/<siglum>
    def add_from_concordant(concordant_element, children = false, new_siglum = nil)
      raise(ArgumentError, "Can only create concordant catalog elements from Cards") unless(concordant_element.is_a?(ExpressionCard))
      siglum = new_siglum || concordant_element.siglum || concordant_element.uri.local_name
      new_el = concordant_element.clone_concordant(self.uri + '/' + siglum)
      new_el.catalog = self
      
      if(children)
        for_children_of(concordant_element) do |child|
          new_clone = add_from_concordant(child, true)
          new_clone.hyper::part_of << new_el
          new_clone.save!
        end
      end
      
      new_el
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
    protected
    
    
    # Goes through the children of the given element
    def for_children_of(element)
      children = Source.find(:all, :find_through => [N::HYPER.part_of, element])
      children.each { |child| yield(child) }
    end
    
  end
  
end
