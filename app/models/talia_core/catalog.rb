module TaliaCore
  
  # A catalog is a collection of AbstractWorkCard records. 
  class Catalog < Source
    
    # Returns all the elements, restricting the result to the given type
    # if one is given. The type should be a class.
    def elements(type = nil)
      type ||= Source
      raise(ArgumentError, "Type for elements should be a class") unless(type.is_a?(Class))
      type.find(:all, :find_through => [N::HYPER.is_part_of, self])
    end
    
    # Add an element to the catalog. If the add_relatives flag is set, 
    # also the parents (elements that this thing is part of) and children
    # (parts of this element) will be added.
    def add(element, add_relatives = false)
      raise(ArgumentError, "Can only add Sources") unless(element.is_a?(Source))
      element.catalog = self
      
    end
    
    protected
    
    # Adds the "parent elements" of the current one
    def add_super_elements(element)
      parents = Source.find(:all, :find_through_inv => [N::HYPER.is_part_of, element])
      parents.each do |parent_el|
        parent_el.cat
      end
    end
    
    
  end
  
end
