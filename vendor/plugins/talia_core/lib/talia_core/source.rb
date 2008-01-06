# require 'objectproperties' # Includes the class methods for the object_properties
require 'local_store/source_record'
require 'local_store/data_record'
require 'query/source_query'
require 'active_rdf'
require 'semantic_naming'
require 'dummy_handler'
require 'rdf_resource_wrapper'
require 'rdf_helper'
require 'source_property_list'
require 'type_list'
require 'json'

module TaliaCore
  
  # This represents a Source in the Talia core system.
  #
  # Since data for the Source exists both in the database and in the RDF store, the 
  # handling/saving of data is a bit peculiar at the moment (subject to change in the future):
  #
  # * When a new Source is created, no data is saved
  # * RDF properties *cannot* be written until the Source has been saved for the first time
  # * Database properties are *only* written when the save method is called
  # * RDF properties are written immediately when they are assigned
  # * To ensure that the data is written, the save method should be called as 
  #   necessary.
  class Source
    
    # Creates a new Source from a uri
    # If a source with the given URI already exists, this will load the given
    # source (no types can be given in that case)
    #
    # If a new record is created, the empty record will be *immediately* saved to the database.
    # This is to avoid "orpahn" RDF records.
    def initialize(uri, *types)
      return load_record(uri) if(uri.is_a?(SourceRecord)) # Shortcut if a record is given directly
      
      existing_record = nil
      
      uri = Source.build_query_uri(uri)
      
      if(SourceRecord.exists_uri?(uri))
        if(types && types.size > 0)
          raise(DuplicateIdentifierError, 
            "Source already exists, cannot create with new type information: " + uri)
        end
        existing_record = SourceRecord.find_by_uri(uri)
      end
      
      if(existing_record)
        load_record(existing_record)
      else
        create_record(uri, types)
      end
    end
    
    # Get the id for this record (equals to it's local name)
    def id
      uri.local_name
    end
    
    # Alias for id, used by Rails magic
    alias_method :to_param, :id
    
    # Indicates if this source belongs to the local store
    def local
      uri.local?
    end
    
    # Check if this object is valid.
    # This checks if the constraints for the Source are met.
    # Currently this only checks the constraints on the database
    # object.
    def valid?
      @source_record.valid? 
    end
    
    # Saves the data for this resource. On success, it will return the
    # record itself, upon failure it will return nil.
    def save()
      retval = self
      begin
        save!
      rescue
        retval = nil
      end
      
      retval
    end
    
    # Saves the data for this resource and raises error on Failure.
    # This will perform three actions:
    # 
    # * Remove the duplicated db entries from the RDF store
    # * Write the database record
    # * Write th duplicated db entries to the RDF store.
    #
    # If one of the operations fails, the database transaction will be rolled 
    # back. The RDF transaction cannot be rolled back, but this guarantees that
    # upon a successful save the "duplicate" values are written.
    def save!()
      # TODO: Add permission checking
      
      # We wrap this in a transaction: If the RDF save fails,
      # the database save will be rolled back
      SourceRecord.transaction do
        remove_db_dupes!
        @source_record.save!()
        write_db_dupes!
      end
      
      @exists = true
    end

    
    # Accessor for the error messages (after validation)
    # At the moment, these are only the object store messages
    def errors
      return @source_record.errors
    end
    
    
    # Find Sources in the system
    # If just a single parameter (or a list of N::URI or String) is given, 
    # then we assume that these are the URIs of the Source(s) to load.
    # If one of those does not have the format of an URI, we assume that
    # it's the name of a local Source and prepend the local namespace.
    #
    # If multiple conditions are given, they will be joined by a boolean AND.
    # This uses the SourceQuery and related classes, which can also be used
    # independetly to create more complex queries.
    # 
    # The method can be used in a way similiar to the <tt>ActiveRecord::find</tt> method:
    #
    # * Find by url: You can give one or moren urls, and the method will either return a
    #   Source object (for a single url) or an Array of Source objects (for multiple urls)
    #   If not all of the given urls exist, an error will be raised.
    # * Find first: This will return the first record that is matched by the options given.
    #   remember that this may <b>not</b> be the same as the first record returned by SQL for that
    #   parameters. This is equivalent to :limit => 1 and :offset => 0
    # * Find all: This will return all records matched by the given options.
    #
    # Currently, the following options are supported:
    #
    # * <tt>:type</tt>: Give one or more Source types, the results will only contain the given types
    # * <tt>:limit</tt>: Limits the size of the result set to the given number of elements.
    # * <tt>:offset</tt>: The number of the first element that will be returned
    # * <tt>predicate</tt>: Returns only records where the "predicate" has the given value. The predicate
    #   (hash key) may be either a string or an N::URI object.
    # * <tt>:force_rdf</tt>: If set to true, the query will be executed within the
    #   RDF store completely.
    #
    # Examples for find by uri:
    #   Source.find("http://www.domain.org/thesource") # Finds one uri
    #   Source.find("http://www.domain.org/somesource", "http://www.domain.org/othersource") # Finds multiple uris
    #   Source.find("document") # Finds a resource in the local namespace
    #   Source.find(N::FOOBAR + "id") # Uses the dynamic naming to construct the uri
    #
    # Expamples for find first:
    #   Source.find(:first) # Just selects the "first" source
    #   Source.find(:first, :type => N::DEFAULT + "book") # Select by type
    #
    # Examples for find all:
    #   Source.find(:all) # Finds all Sources
    #   Source.find(:all, :type => N::DEFAULT::book) # Find all Sources of the given type
    def self.find(*params)
      raise(QueryError, "No query string given") unless(params.size > 0)

      first_param = params.first
      find_result = nil

      # If the first param is a String or URI, we query for the given URIs
      if(first_param.is_a?(String) || first_param.kind_of?(N::URI))
        uris = params.collect { |param| build_query_uri(param) }
        find_result = load_from_records(SourceRecord.find_by_uri(uris))
      else
        if(params.size == 1) # Check if it's just find :all or :first
          # Just go to the database
          if(first_param != :first && first_param != :all)
            raise(QueryError, "Illegal find scope: #{params[0]}")
          end
          find_result = load_from_records(SourceRecord.find(params[0]))
        else
          # Builds a query for the given options
          raise(QueryError, "Illegal parameters") unless(params.size == 2)
          qry_opts = params[1]

          if(first_param == :first)
            qry_opts[:limit] = 1
            qry_opts[:offset] = 0
          elsif(first_param != :all)
            raise(QueryError, "Illegal query scope #{first_param}")
          end

          options = {}
          options[:limit] = qry_opts.delete(:limit) if(qry_opts[:limit])
          options[:offset] = qry_opts.delete(:offset) if(qry_opts[:offset])
          options[:force_rdf] = qry_opts.delete(:force_rdf) if(qry_opts[:force_rdf])
          options[:conditions] = qry_opts

          find_result = SourceQuery.new(options).execute
          
          if(first_param == :first)
            assit(find_result.size == 0 || find_result.size == 1, "Illegal result size for :first: #{find_result.size}")
            find_result = find_result[0]
          elsif(first_param != :all)
            raise(QueryError, "Illegal find scope #{first_param}")
          end
        end
      end
             
      assit(find_result.is_a?(Source) || find_result.is_a?(Array) || find_result == nil)
      find_result
    end
    
    # Checks if the current record already exists in the database
    def exists?
      @exists = Source.exists?(uri)
    end
    
    # Checks if a source with the given uri exists in the system
    def self.exists?(uri)
      # A source exists if the respective record exists in the
      # database store
      uri = build_query_uri(uri)
      return SourceRecord.exists_uri?(uri)
    end
    
    # Returns an array of the predicates that are directly defined for this
    # Source. This will return a list of URIs that will access valid 
    # attributes on this Source.
    def direct_predicates
      @rdf_resource.direct_predicates
    end
    
    # Returns an array of the "inverse" predicates of this source. These are
    # the predicates for which this source exists as an object
    def inverse_predicates
      qry = Query.new.distinct.select(:p)
      qry.where(:s, :p, RDFS::Resource.new(uri.to_s))
      qry.execute.collect{ |res| N::Predicate.new(res.uri) }
    end
    
    # Returns a TypeList with the types of this Source
    def types
      TypeList.new(@source_record.type_records)
    end
    
    # Redirect the call to the :type_records
    alias :type_records :types
    
    # Attribute reader, for compatibility with the ActiveRecord API
    # If the given name is a database field, the called will be
    # passed to the database. Otherwise, this will assume that 
    # the parameter is the URI of a RDF property.
    def [](attribute)
      attr = nil
      
      if(@source_record.attribute_names.include?(attribute.to_s))
        attr = @source_record[attribute.to_s]
      else
        attr = @rdf_resource[attribute.to_s]
      end
      
      attr
    end
    
    # Assignment to the the array-type accessor
    def []=(attribute, value)
      if(@source_record.attribute_names.include?(attribute.to_s))
        @source_record[attribute.to_s] = value
      else
        raise(ArgumentError, "Set not available on RDF properties, use << instead.")
      end
    end
    
    # This returns a special object which collects the "inverse" properties 
    # of the Source - these are all RDF properties which have the current
    # Source as the object.
    #
    # The returned object supports the [] operator, which allows to fetch the
    # "inverse" (the RDF subjects) for the given predicate.
    #
    # Example: <tt>person.inverse[N::FOO::creator]</tt> would return a list of
    # all the elements of which the current person is the creator.
    def inverse
      my_inverse = Object.new
      my_inverse.instance_variable_set(:@rdf_inverse, @rdf_resource.inverse)
      
      class << my_inverse
        include RdfHelper
        
        def [](pred_uri)
          to_sources(@rdf_inverse[pred_uri.to_s])
        end
      end
      
      return my_inverse
    end
    
    # Accessor that allows to lookup a namespace/name combination. This works like
    # the [] method: It will return a SourcePropertyList
    def predicate(namespace, name)
      namesp_uri = N::Namespace[namespace]
      
      # Only return something if the namespace exits.
      namesp_uri ? self[namesp_uri + name.to_s] : nil
    end
    
    # Setter method for predicates by namespace/name combination. This works like
    # the = operator for a property: *It will add a precdicate triple, not replace one!*
    def predicate_set(namespace, name, value)
      raise_if_unsaved
      
      namesp_uri = N::Namespace[namespace]
      
      # Check if namespace exists
      namesp_uri ? self[namesp_uri + name.to_s] << value : false
    end
    
    # Creates a simple XML representation of the Source
    def to_xml
      xml = String.new
      builder = Builder::XmlMarkup.new(:target => xml, :indent => 2)
      
      # Xml instructions (version and charset)
      builder.instruct!
      
      builder.source(:primary => primary_source) do
        builder.id(@source_record.id, :type => "integer")
        builder.uri(uri.to_s)
        builder.name(@source_record.name)
        builder.workflow_state(@source_record.workflow_state, :type => "integer")
        builder.primary_source(@source_record.primary_source, :type => "boolean")
      end
      
      xml
    end
    
    # Creates an RDF/XML resprentation of the source
    def to_rdf
      xml = String.new
      
      builder = Builder::XmlMarkup.new(:target => xml, :indent => 2)
      
      # Xml instructions (version and charset)
      builder.instruct!
      
      # Build the namespaces
      namespaces = {}
      N::Namespace.shortcuts.each { |key, value| namespaces["xmlns:#{key.to_s}"] = value.to_s }
      
      builder.rdf :RDF, namespaces do # The main RDF/XML element
        builder.rdf :Description, :about => uri do # Element describing this resource
          # loop through the predicates
          direct_predicates.each do |predicate|
            predicate_rdf(predicate, builder)
          end
        end
      end
      
    end
    
    # To string: Just return the URI. Use to_xml if you need something more
    # involved.
    def to_s
      uri.to_s
    end
    
    
    # JSON representation of the Source: Just the URL. This doesn' really store
    # all information, but it avoids serialization problems
    def to_json(*)
      {
        'json_class' => self.class.name,
        'uri' => uri
      }.to_json
    end
    
    # JSON deserializer: Just create a new object with the url
    def self.json_create(object)
      new(object['uri'])
    end
    
    protected
    
    
    # Class methods
    class << self
      
      # Build an uri from a string that was given from a query.
      # If this already is a uri, it will just be returned. 
      # If this is not an URI, it will return a URI with the given name in the 
      # local namespace
      def build_query_uri(orig_string)
        uri = orig_string.to_s
        
        if(!N::URI.is_uri?(uri))
          uri = (N::LOCAL + uri).to_s
        end
        
        return  uri
      end
      
      # Get the "RDF name" of a DB item
      def db_item_to_rdf(item)
        if(item == :type)
          N::RDF::type
        else
          (N::TALIA_DB + item.to_s).to_s
        end
      end
      
      # Loads a list of existing records into the system. This will
      # return an Array of Source objects, the records can be given
      # as a list of SourceRecord objects, or as a single Array.
      def load_from_records(*existing_records)
        existing_records = existing_records[0] if(existing_records[0].kind_of?(Array))
        
        existing_records = existing_records.collect { |record| Source.new(record) }
        # flatten the array if neccessary
        existing_records.size == 1 ? existing_records[0] : existing_records
      end
      
    end
    
    # End of class methods
  
    # Loads an existing record into the system
    def load_record(existing_record)
      assit_type(existing_record, SourceRecord)
      assit_not_nil(existing_record.uri)
      
      # Our local store is the record given to us
      @source_record = existing_record
      
      # Create the RDF object
      @rdf_resource = RdfResourceWrapper.new(existing_record.uri.to_s)  
    end
  
    # Creates a brand new Source object
    def create_record(uri, new_types)
      
      # Contains the interface to the part of the data that is
      # stored in the database
      @source_record = SourceRecord.new(uri.to_s)
      
      # Contains the interface to the ActiveRDF 
      @rdf_resource = RdfResourceWrapper.new(uri.to_s)
      
      # Insert the types
      for type in new_types do
        types << N::SourceClass.new(type.to_s)
      end
      
    end
    
    # Writes the duplicates for the database properties to the
    # RDF store. Saves the rdf resource.
    def write_db_dupes!
      db_columns_each do |col|
        @rdf_resource[Source::db_item_to_rdf(col)] << @source_record[col]
      end
      # Write the types
      types.each { |type| @rdf_resource[N::RDF::type] << Source.new(type) }
   
      @rdf_resource.save
    end
    
    # Removes the duplicates for the database properties from the
    # RDF store. Saves the rdf resource.
    def remove_db_dupes!
      db_columns_each do |col|
        db_dupe = @rdf_resource[Source::db_item_to_rdf(col)]
        db_dupe.remove
      end
      
      # Remove the types
      @rdf_resource[N::RDF::type].remove
      
      @rdf_resource.save
    end
    
    # Executes the given block for each database column, passing
    # the name of the column as a parameter. 
    #
    # This gets the columns from ActiveRecord::Base#content_columns
    def db_columns_each(&block)
      SourceRecord.content_columns.each do |col|
        block.call(col.name)
      end
    end
    
    # Raises an error if the underlying record is not saved yet
    def raise_if_unsaved
      if(!exists?)
        raise(UnsavedSourceError, "Cannot set elements on unsaved Source #{uri.to_s}.")
      end
    end
    
    # Missing methods: This first checks if the method called 
    # corresponds to a valid database attribute. In this case,
    # the call will be passed to the database.
    #
    # Otherwise, the call goes to the RDF store, as explained below.
    # 
    # There are 3 possibilities for RDF, which are processed in that order:
    # 
    # 1. The method name is a shortcut for a PredicateType. In that
    #    case, we use that predicate for the resource. We don't expect
    #    any arguments.
    #    OR
    #    The method name is a shortcut for a generic URI, in which case we
    #    use it like a predicate
    # 2. The method name is the shortcut for a Namespace. In that case,
    #    we expect an argument which can be appended to the Namespace
    #    as a string
    # 3. The method name is unknown, in which case we use it in the
    #    default namespace.
    def method_missing(method_name, *args)
      # TODO: Add permission checking for all updates to the model
      # TODO: Add permission checking for read access?
      
      update = method_name.to_s[-1..-1] == '='
      
      shortcut = if update 
        method_name.to_s[0..-2]
      else
        method_name.to_s
      end
      
      arg_count = update ? (args.size - 1) : args.size
      
      # Check if this call should go to the db
      if(@source_record.attribute_names.include?(shortcut.to_s))
        if(update)
          return @source_record[shortcut.to_s] = args[-1]
        else
          return @source_record[shortcut.to_s]
        end
      end
      
      # Check for associated database records
      # This has to be checked/called "manually" because the
      # associated types are not properties of the ActiveRecord
      if(assoc = SourceRecord.reflect_on_association(shortcut.to_sym))
        case assoc.macro
        when :has_many
          return @source_record.send(shortcut.to_s)
        when :has_one
          if(update)
            return @source_record.send(method_name.to_s, args[0])
          else
            return @source_record.send(shortcut.to_s)
          end
        else
          assit(false, "Invalid association type")
          return false
        end
      end
      
      # Otherwise, check for the RDF predicate
      registered = N::URI[shortcut.to_s]
      predicate = nil
      
      if(!registered)
        # Possibility 4.
        predicate = N::DEFAULT + shortcut.to_s
      elsif(registered.kind_of?(N::Namespace))
        # Possibility 2.
        raise(SemanticNamingError, "Namespace invoked incorrectly") if(arg_count != 0)
        # Return "dummy handler" that will catch the namespace::name invocation
        return DummyHandler.new(registered, @rdf_resource)
      elsif(registered.kind_of?(N::SourceClass))
        raise(SemanticNamingError, "Can't use source class as a predicate.")
      elsif(registered.kind_of?(N::URI))
        # Possibility 1.: Predicate or generic URI
        raise(SemanticNamingError, "No additional parameters can be given with predicate") if(arg_count != 0)
        predicate = registered
      else
        # Error: Wrong type
        raise(SemanticNamingError, "Unexpected type in semantic naming")
      end
      
      if update
        raise_if_unsaved
        @rdf_resource[predicate.to_s] << args[-1]
      else
        @rdf_resource[predicate.to_s]
      end
    end
    
    # Build an rdf/xml string for one predicate
    def predicate_rdf(predicate, builder)
      builder.tag!(predicate.to_name_s) do
        # Get the predicate values
        self[predicate.to_s].each do |value|
          # If we have a (re)Source, we have to put in another description tag.
          # Otherwise, we will take just the string
          if(value.kind_of?(Source))
            builder.rdf :Description, "rdf:about" => value.uri.to_s
          else
            builder.text!(value.to_s)
          end
        end # end predicate loop
      end # end tag!
    end # end method
    
  end
end
