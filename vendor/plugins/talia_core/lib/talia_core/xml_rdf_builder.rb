module TaliaCore
  
  # Class for creating xml-rdf data
  class XmlRdfBuilder
    
    # Creates a new builder. The options are equivalent for the options of the
    # underlying Xml builder. The builder itself will be passed to the block that
    # is called by this method.
    # If you pass a :builder option instead, it will use the given builder instead
    # of creating a new one
    def self.open(options)
      my_builder = self.new(options)
      my_builder.send(:build_structure) do
        yield(my_builder)
      end
    end
   
    # Writes a simple "flat" triple. If the object is a string, it will be
    # treated as a "value" while an object (ActiveSource or N::URI) will be treated
    # as a "link"
    def write_triple(subject, predicate, object)
      subject = subject.respond_to?(:uri) ? subject.uri.to_s : subject
      predicate = predicate.respond_to?(:uri) ? predicate : N::URI.new(predicate) 
      @builder.rdf :Description, "rdf:about" => subject do
        write_predicate(predicate, [ object ])
      end
    end
   
    # Writes a complete source to the rdf
    def write_source(source)
      @builder.rdf :Description, 'rdf:about' => source.uri.to_s do # Element describing this resource
        # loop through the predicates
        source.direct_predicates.each do |predicate|
          write_predicate(predicate, source[predicate])
        end
      end
    end
   
    private 
    
    # Create a new builder
    def initialize(options)
      @builder = options[:builder]
      @builder ||= Builder::XmlMarkup.new(options)
    end
    
    # Build the structure for the XML file and pass on to
    # the given block
    def build_structure
      @builder.rdf :RDF, self.class.namespaces do 
        yield
      end
    end
    

    def self.namespaces
      @namespaces ||= begin
        namespaces = {}
        N::Namespace.shortcuts.each { |key, value| namespaces["xmlns:#{key.to_s}"] = value.to_s }
        namespaces
      end
    end
    
    # Build an rdf/xml string for one predicate, with the given values
    def write_predicate(predicate, values)
      @builder.tag!(predicate.to_name_s) do
        # Get the predicate values
        values.each do |value|
          # If we have a (re)Source, we have to put in another description tag.
          # Otherwise, we will take just the string
          if(value.respond_to?(:uri))
            @builder.rdf :Description, "rdf:about" => value.uri.to_s
          else
            @builder.text!(value.to_s)
          end
        end # end predicate loop
      end # end tag!
    end # end method
    
  end
end