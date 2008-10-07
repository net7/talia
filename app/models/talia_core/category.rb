module TaliaCore
  
  # A category may group Sources by a user-defined selection. Each Source
  # should only have a single category.
  class Category < ExpressionCard
    
    singular_property :name, N::HYPER.name
    singular_property :description, N::DCNS.description

    # Returns all sources in this category, optionally limiting to the
    # given source class
    def members(source_class = nil)
      source_class ||= ActiveSource
      source_class.find(:all, :find_through => [N::HYPER.category, self])
    end
    
  end
  
end
