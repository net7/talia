module TaliaCore #:nodoc:
  # A +MacroContribution+ is a generic collection of sources.
  class MacroContribution < Source
    
    # FIXME on app boot it raises an error, because doesn't know about N::HYPER
    #    SOURCE_PREDICATE = N::HYPER + 'hasAsPart'
    SOURCE_PREDICATE =  'http://www.hypernietzsche.org/ontology#hasAsPart'

    attr_writer :title, :description, :macrocontribution_type

    def sources #:nodoc:
      @sources ||= self[SOURCE_PREDICATE]
    end
        
    # Needed for the proper init
    def self.new(uri)
      super(uri)
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
