module TaliaCore
  
  # This class encapsulates all functionality to access a specific resource
  # in the RDF store. It is analogous to the RDFS::Resource class in ActiveRDF.
  #
  # However, it's specifically tailored for the use with Talia, and avoids some
  # of the pitfalls of the original class.
  class RdfResource
    
    class << self
      
      # A list of "default" types that will be added to all resources
      def default_types
        @default_types ||= [
          N::SourceClass.new(N::RDFS.Resource)
        ]
      end
      
    end
    
    # The class of objects that will be "produced" by this RdfResource
    attr_writer :object_class
    
    def object_class
      @object_class ||= TaliaCore::Source
    end
    
    # Initialize a new resource with the given URI
    def initialize(uri)
      @uri = N::URI.new(uri)
    end

    # Direct writing of a predicate, with having to fetch a list first
    def direct_write_predicate(predicate, value)
      FederationManager.add(self, predicate, value)
    end

    # Clears all rdf for this resource. FIXME: Not context-aware.
    def clear_rdf
      FederationManager.delete(self, nil, nil)
    end


    # Returns the value(s) of the given predicates as a PropertyList filled
    # with the defined object_class objects.
    def [](predicate)
      predicate = N::URI.new(predicate) unless(predicate.kind_of?(N::URI))
      
      property_list = Query.new(object_class).distinct(:o).where(self, predicate, :o).execute
      
      PropertyList.new(predicate, property_list, self, source_exists?)
    end
    
    # Returns an on-the-fly object that can be used to query for "inverse"
    # properties of this resource (meaning triples that have the current 
    # resource as an object.) 
    #
    # The returned object will respond to a [] (array accessor) call which 
    # allows the user to specify the predicate to use.
    #
    # Example: <tt>resource.inverse[N::DNCS::title]</tt>
    #
    # The [] method will return a list of objects that are instances of object_class
    def inverse
      inverseobj = Object.new
      inverseobj.instance_variable_set(:@obj_uri, self)
      inverseobj.instance_variable_set(:@obj_class, object_class)
      
      class <<inverseobj     
        
        def [](property)
          property = N::URI.new(property) unless(property.kind_of?(N::URI))
          Query.new(@obj_class).distinct(:s).where(:s, property, @obj_uri).execute
        end
        private(:type)
      end
      
      return inverseobj
    end
    
    
    # Returns the uri of this resource as a string
    def uri
      @uri.to_s
    end
    
    # Returns the predicates that are directly defined for this resource
    def direct_predicates
      Query.new(N::Predicate).distinct(:p).where(self, :p, :o).execute
    end
    
    # Returns the "inverse" predicates for the resource. these are the predicates
    # for which this resource exists as an object
    def inverse_predicates
      qry = Query.new.distinct.select(:p)
      qry.where(:s, :p, N::URI.new(uri.to_s))
      qry.execute.collect{ |res| N::Predicate.new(res.uri) }
    end
    
    # Saves the current resource and it's properties to the RDF. (This has
    # been optimized so that if only one RDF backend is present it won't do
    # any copying around.
    def save
      if((ConnectionPool.read_adapters.size == 1) &&
            (ConnectionPool.write_adapter == ConnectionPool.read_adapters.first))
        save_default_types # Only write the "default" types to the store
      else
        full_save # Do the full save operation
      end
    end
    
    # Returns the types of this resource as N::SourceClass objects
    def types
      types = Query.new(N::SourceClass).distinct(:t).where(self,N::RDF::type,:t).execute
      # Add the "default" types if necessary
      self.class.default_types.each do |def_type|
        types << def_type unless(types.include?(def_type))
      end
      
      # Make a property list for the types.
      PropertyList.new(N::RDF::type, types, self, source_exists?)
    end
    
    private
    
    # Saves the the "default" types of this resource to the writing adapter
    def save_default_types
      self.class.default_types.each do |t|
        FederationManager.add(self, N::RDF::type, t)
      end
    end
    
    # "Full" save which reads the triples from all adapters, and saves them
    # the writing adapter. This operation can be very slow.
    def full_save
      types.each do |t|
        FederationManager.add(self, N::RDF::type, t)
      end

      Query.new(N::URI).distinct(:p,:o).where(self, :p, :o).execute do |p, o|
        FederationManager.add(self, p, o)
      end
    end
    
    # Returns true if the corresponding Source already exists in the database
    def source_exists?
      # FIXME: Just a helper as long as ActiveSource is not completely integrated!
      Source.exists?(@uri) || ActiveSource.exists?(:uri => @uri.to_s)
    end
    
  end
end
