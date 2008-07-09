module TaliaCore #:nodoc:
  # A +MacroContribution+ is a generic collection of sources.
  class MacroContribution < Source
    # FIXME on app boot it raises an error, because doesn't know about N::HYPER
#    SOURCE_PREDICATE = N::HYPER + 'hasAsPart'
    SOURCE_PREDICATE = 'hasAsPart'

    attr_writer :title, :description, :macrocontribution_type

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
          add Source.new(source)
        else 
          sources << source
      end
    end
    alias_method :<<, :add

    delegate :remove, :include?, :to => :sources

    def save
      super
      [:title, :description, :macrocontribution_type].each do |attribute|
        self.predicate(:hyper, attribute.to_s).remove
        self.predicate_set(:hyper, attribute.to_s, send(attribute))
      end
    end
    
    def title
      @title ||= self.hyper::title.last
    end
    
    def description
      @description ||= self.hyper::description.last
    end
    
    def macrocontribution_type
      @macrocontribution_type ||= self.hyper::macrocontribution_type.last
    end
  end  
end  
