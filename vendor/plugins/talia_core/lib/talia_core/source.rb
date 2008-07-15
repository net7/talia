# require 'objectproperties' # Includes the class methods for the object_properties
require 'source_transfer_object'
require 'active_rdf'
require 'semantic_naming'
require 'dummy_handler'
require 'rdf_resource'

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
  class Source < ActiveSource
 
    has_many :data_records, :class_name => 'TaliaCore::DataTypes::DataRecord', :dependent => :destroy
    has_one :workflow, :class_name => 'TaliaCore::Workflow::Base', :dependent => :destroy
    
    # The uri will be wrapped into an object
    def uri
      N::URI.new(self[:uri])
    end
    
    # Indicates if this source belongs to the local store
    def local
      uri.local?
    end
    
    # Wrapping for <tt>ActiveRecord</tt> <tt>update_attributes</tt>.
    def update_attributes(attributes)
      source_record_attributes, attributes = extract_attributes!(attributes)
      @source_record.update_attributes(source_record_attributes)
      attributes.each do |k,v|
        send(k + "=", v)
        send('save_' + k)
      end
    end
    
    # Shortcut for assigning the primary_source status
    def primary_source=(value)
      value = value ? 'true' : 'false'
      predicate_set(:talia, :primary_source, value)
    end
    
    # Indicates if the current source is considered "primary" in the local 
    # library
    def primary_source
      predicate(:talia, :primary_source) == true
    end
    
    # Searches for sources where <tt>property</tt> has one of the values given
    # to this method. The result is a hash that contains one result list for
    # each of the values, with the value as a key.
    # 
    # This performs a find operation for each value, and the params passed
    # to this method are added to the find parameters for each of those finds.
    #
    # *Example*
    #  
    #  # Returns all Sources that are of the RDFS type Class or Property. This
    #  # will return a hash with 2 lists (one for the Classes, and one for the
    #  # properties, and each list will be limited to 5 elements.
    #  Source.groups_by_property(N::RDF::type, [N::RDFS.Class, N::RDFS.Property], :limit => 5)
    def self.groups_by_property(property, values, params = {})
      # First create the joins
      joins = 'LEFT JOIN semantic_relations ON semantic_relations.subject_id = active_sources.id '
      joins << "LEFT JOIN active_sources AS t_sources ON semantic_relations.object_id = t_sources.id AND semantic_relations.object_type = 'TaliaCore::ActiveSource' "
      joins << "LEFT JOIN semantic_properties ON semantic_relations.object_id = semantic_properties.id AND semantic_relations.object_type = 'TaliaCore::SemanticProperty' "
      
      property = uri_string_for(property)
      results = {}
      for val in values
        find(:all )
        val_str = uri_string_for(val)
        find_parms = params.merge(
          :conditions => ['semantic_properties.value = ? OR t_sources.uri = ?', val_str, val_str],
          :joins => joins
        )
        results[val] = find(:all, find_parms)
      end
      
      results
    end
    
    # Find a list of sources which contains the given token inside the local name.
    # This means that the namespace it will be excluded.
    #
    #   Sources in system:
    #     * http://talia.org/one
    #     * http://talia.org/two
    #
    #   Source.find_by_uri_token('a') # => [ ]
    #   Source.find_by_uri_token('o') # => [ 'http://talia.org/one', 'http://talia.org/two' ]
    #
    # NOTE: It internally use a MySQL function, as sql condition, to find the local name of the uri.
    def self.find_by_uri_token(token, options = {})
      find(:all, { 
          :conditions => [ "LOWER(SUBSTRING_INDEX(uri, '/', -1)) LIKE ?", '%' + token.downcase + '%' ], 
          :select => :uri,
          :order => "uri ASC",
          :limit => 10 }.merge!(options))
    end
   
    # Return an hash of direct predicates, grouped by namespace.
    def grouped_direct_predicates
      direct_predicates.inject({}) do |result, predicate|
        predicates = self[predicate].collect { |p| SourceTransferObject.new(p.to_s) }
        namespace = predicate.namespace.to_s
        result[namespace] ||= {}
        result[namespace][predicate.local_name] ||= []
        result[namespace][predicate.local_name] << predicates
        result
      end
    end
    
    # Returns a flat uri (as string) list of associated rdf objects (triple endpoint).
    def direct_predicates_objects
      @direct_predicates_objects ||= direct_predicates.collect do |predicate|
        self[predicate].map(&:to_s)
      end.flatten
    end
    
    # Check if the current source is related with the given rdf object (triple endpoint).
    def associated?(object)
      direct_predicates_objects.include? object.to_s
    end
    
    attr_reader :predicates_attributes
    def predicates_attributes=(predicates_attributes)
      @predicates_attributes = predicates_attributes.collect do |attributes_hash|
        attributes_hash['object'] = instantiate_source_or_rdf_object(attributes_hash)
        attributes_hash
      end
    end

    # Save, associate/disassociate given predicates attributes.
    def save_predicates_attributes
      each_predicate_attribute do |namespace, name, object, should_destroy|
        object.save if object.is_a? Source and object.new_record?
        self.predicate_set(namespace, name, object) unless associated? object
        self.predicate(namespace, name).remove(object) if should_destroy
      end
    end
    
    # This will return a list of DataRecord objects. Without parameters, this
    # returns all data elements on the source. If a type is given, it will
    # return only the elements of the given type. If both type and location are
    # given, it will retrieve only the specified data element
    def data(type = nil, location= nil)
      find_type = location ? :first : :all # Find just one element if a location is given
      options = {}
      options[:conditions] = [ "type = ?", type ] if(type && !location)
      options[:conditions] = [ "type = ? AND location = ?", type, location ] if(type && location)
      data_records.find(find_type, options)
    end
    
    # Returns an array of labels for this source. You may give the name of the
    # property that is used as a label, by default it uses rdf:label(s). If
    # the given property is not set, it will return the local part of this
    # Source's URI.
    #
    # In any case, the result will always be an Array with at least one elment.
    def labels(type = N::RDFS::label)
      labels = get_attribute(type)
      unless(labels && labels.size > 0)
        labels = [uri.local_name]
      end

      labels
    end
    
    # This returns a single label of the given type. (If multiple labels
    # exist in the RDF, just the first is returned.)
    def label(type = N::RDFS::label)
      labels(type)[0]
    end
    
    # Creates a simple XML representation of the Source
    def to_xml
      xml = String.new
      builder = Builder::XmlMarkup.new(:target => xml, :indent => 2)
      
      # Xml instructions (version and charset)
      builder.instruct!
      
      builder.source(:primary => primary_source) do
        builder.id(id, :type => "integer")
        builder.uri(uri.to_s)
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
    
    # Return the titleized uri local name.
    #
    #   http://localnode.org/source # => Source
    def titleized
      self.uri.local_name.titleize
    end
    
    # Equality test. Two sources are equal if they have the same URI
    def ==(value)
      value.is_a?(Source) && (value.uri == uri)
    end
    
    def normalize_uri(uri, label = '')
      self.class.normalize_uri(uri, label)
    end
    
    protected
    
    # Separates given attributes distinguishing between Source related and SourceRecord related.
    def extract_attributes!(attributes)
      source_record_attributes = attributes.inject({}) do |source_record_attributes, column_values|
        source_record_attributes[column_values.first] = attributes.delete(column_values.first) if SourceRecord.column_names.include? column_values.first
        source_record_attributes
      end

      [ source_record_attributes, attributes ]
    end
    
    # Look at the given attributes and choose to instantiate
    # a Source or a RDF object (triple endpoint).
    #
    # Cases:
    #   Homer Simpson
    #     # => Should instantiate a source with
    #     http://localnode.org/Homer_Simpson using N::LOCAL constant.
    #
    #   "Homer Simpson"
    #     # => Should return the string itself, without the double quoting
    #     in order to add it directly to the RDF triple.
    #
    #   http://springfield.org/Homer_Simpson
    #     # => Should instantiate a source with the given uri
    def instantiate_source_or_rdf_object(attributes)
      name_or_uri = attributes['titleized']
      if /^\"[\w\s\d]+\"$/.match name_or_uri
        name_or_uri[1..-2]
      elsif attributes['uri'].blank? and attributes['source'].blank?
        name_or_uri
      elsif /^http:\/\//.match name_or_uri
        # TODO remove the block, setting those defaults into the related migration.
        source = Source.new(name_or_uri)
        source.primary_source = false
        source
      else
        # TODO remove the block, setting those defaults into the related migration.
        source = Source.new(normalize_uri(attributes['uri'], name_or_uri))
        source.primary_source = false
        source
      end
    end
    
    # Iterate through predicates_attributes, yielding the given code.
    def each_predicate_attribute(&block)
      predicates_attributes.each do |attributes_hash|
        object         = attributes_hash['object']
        namespace      = attributes_hash['namespace'].to_sym
        name           = attributes_hash['name']
        should_destroy = attributes_hash['should_destroy'].to_i == 1
        block.call(namespace, name, object, should_destroy)
      end
    end
        
    # Class methods
    class << self
      
      # Normalize the given uri.
      #
      # Example:
      #   normalize_uri('Lucca') # => http://www.talia.discovery-project.org/sources/Lucca
      #   normalize_uri('http://xmlns.com/foaf/0.1/Group') # => http://xmlns.com/foaf/0.1/Group
      #   normalize_uri('http://www.talia.discovery-project.org/sources/Lucca')
      #     # => http://www.talia.discovery-project.org/sources/Lucca
      def normalize_uri(uri, label = '')
        uri = N::LOCAL if uri.blank?
        uri = N::LOCAL+label.gsub(' ', '_') if uri == N::LOCAL.to_s
        uri.to_s
      end
    end
    
    # End of class methods
    
    
    # Missing methods: This just check if the given method corresponds to a
    # registered namespace. If yes, this will return a "dummy" handler that
    # allows access to properties.
    # 
    # This will allow invocations as namespace::name
    def method_missing(method_name, *args)
      # TODO: Add permission checking for all updates to the model
      # TODO: Add permission checking for read access?
      
      update = method_name.to_s[-1..-1] == '='
      
      shortcut = if update 
        method_name.to_s[0..-2]
      else
        method_name.to_s
      end

      # Otherwise, check for the RDF predicate
      registered = N::URI[shortcut.to_s]
      
      return super(method_name, *args) unless(registered) # normal handler if not a registered uri
      raise(ArgumentError, "Must give a namspace as argument") unless(registered.is_a?(N::Namespace))
      
      DummyHandler.new(registered, self)
    end
    
    
    # Build an rdf/xml string for one predicate
    def predicate_rdf(predicate, builder)
      builder.tag!(predicate.to_name_s) do
        # Get the predicate values
        self[predicate.to_s].each do |value|
          # If we have a (re)Source, we have to put in another description tag.
          # Otherwise, we will take just the string
          if(value.respond_to?(:uri))
            builder.rdf :Description, "rdf:about" => value.uri.to_s
          else
            builder.text!(value.to_s)
          end
        end # end predicate loop
      end # end tag!
    end # end method
    
    
  end
end
