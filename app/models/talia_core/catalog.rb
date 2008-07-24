module TaliaCore
  
  # A catalog is a collection of AbstractWorkCard records. 
  class Catalog
    
    # Returns all the elements, restricting the result to the given type
    # if one is given
    def elements(type = nil)
      # TODO: Implementation
    end
    
    # Add an element to the catalog. If the add_relatives flag is set, 
    # also the parents (elements that this thing is part of) and children
    # (parts of this element) will be added.
    def add(element, add_relatives = false)
      # TODO: Implementation
    end
    
  end
  
end
