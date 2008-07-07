module TaliaCore #:nodoc:
  # A +MacroContribution+ is a generic collection of sources.
  class MacroContribution < Source
    SOURCE_PREDICATE = N::HYPER::hasAsPart

    def initialize(uri, *types) #:nodoc:
      super(uri, *types)
      self.primary_source = false
    end

    def sources #:nodoc:
      @sources ||= self[SOURCE_PREDICATE]
    end

    # Add a +Source+ to the collection
    def add(source)
      raise ArgumentError unless source
      case source
        when String
          self.add Source.new(source)
        else 
          sources << source
      end
    end
    alias_method :<<, :add

    # Remove the given +Source+ from the collection.
    def remove(source)
      sources.remove source
    end
    
    def title=(title)
      self.predicate_set(:hyper, "title", title)
    end
    
    def editors_notes=(notes)
      self.predicate_set(:hyper, 'editorsNotes', notes)
    end
    
    def macrocontribution_type=(type)
      self.predicate_set(:hyper, "macrocontributionType", type)      
    end
    
    def title
      self.hyper::title
    end
    
    def editors_notes
      self.hyper::editorsNotes
    end
    
    def macrocontribution_type
      self.hyper::macrocontributionType
    end
  end  
end  
