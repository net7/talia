module TaliaCore
  
  # A series in which other Sources have been published
  class Series < ExpressionCard
    
    # Get all sources of this series, optionally limit to one source class.
    # Unlike Categories, Series are contributions in themselves.
    def parts(source_class = nil)
      source_class ||= ActiveSource
      source_class.find(:all, :find_through => [N::HYPER.series, self])
    end
    
  end
  
end
