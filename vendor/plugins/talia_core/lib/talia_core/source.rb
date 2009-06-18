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

    alias_method :ar_update_attributes, :update_attributes    
    # Wrapping for <tt>ActiveRecord</tt> <tt>update_attributes</tt>.
    def update_attributes(attributes)
      attributes, rdf_attributes = extract_attributes!(attributes)
      rdf_attributes.each do |k,v|
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
    
    # Try to find a source for the given uri, if not exists it instantiate
    # a new one, combining the N::LOCAL namespace and the given local name
    #
    # Example:
    #   ActiveSource.find_or_instantiate_by_uri('http://talia.org/existent')
    #     # => #<TaliaCore::ActiveSource id: 1, uri: "http://talia.org/existent">
    #
    #   ActiveSource.find_or_instantiate_by_uri('http://talia.org/unexistent', 'Foo Bar')
    #     # => #<TaliaCore::ActiveSource id: nil, uri: "http://talia.org/Foo_Bar">
    def self.find_or_instantiate_by_uri(uri, local_name)
      result = find_by_uri(uri)
      result ||= self.new(N::LOCAL.to_s + local_name.to_permalink)
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
   
    # Find the fist Source that matches the given URI.
    # It's useful for admin pane, because users visit:
    #   /admin/sources/<source_id>/edit
    # but that information is not enough, since we store
    # into the database the whole reference as URI:
    #   http://localnode.org/av_media_sources/source_id
    def self.find_by_partial_uri(id)
      find(:first, :conditions => ["uri LIKE ?", '%' + id + '%'])
    end

    # Return an hash of direct predicates, grouped by namespace.
    def grouped_direct_predicates
      #TODO should it be memoized?
      direct_predicates.inject({}) do |result, predicate|
        predicates = self[predicate].collect { |p| SourceTransferObject.new(p.to_s) }
        namespace = predicate.namespace.to_s
        result[namespace] ||= {}
        result[namespace][predicate.local_name] ||= []
        result[namespace][predicate.local_name] << predicates
        result
      end
    end

    def predicate_objects(namespace, name) #:nodoc:
      predicate(namespace, name).flatten.map(&:to_s)
    end

    # Check if the current source is related with the given rdf object (triple endpoint).
    def associated?(namespace, name, stringified_predicate)
      predicate_objects(namespace, name).include?(stringified_predicate)
    end

    # Check if a predicate is changed.
    def changed?(namespace, name, objects)
      not predicate_objects(namespace, name).eql?(objects.map(&:to_s))
    end

    attr_reader :predicates_attributes
    def predicates_attributes=(predicates_attributes)
      @predicates_attributes = predicates_attributes.collect do |attributes_hash|
        attributes_hash['object'] = instantiate_source_or_rdf_object(attributes_hash)
        attributes_hash
      end
    end

    # Return an hash of new predicated attributes, grouped by namespace.
    def grouped_predicates_attributes
      @grouped_predicates_attributes ||= predicates_attributes.inject({}) do |result, predicate|
        namespace, name = predicate['namespace'], predicate['name']
        predicate = SourceTransferObject.new(predicate['titleized'])
        result[namespace] ||= {}
        result[namespace][name] ||= []
        result[namespace][name] << predicate
        result
      end
    end

    # Save, associate/disassociate given predicates attributes.
    def save_predicates_attributes
      each_predicate do |namespace, name, objects|
        objects.each { |object| object.save if object.is_a?(Source) && object.new_record? }
        self.predicate_replace(namespace, name, objects.to_s) if changed?(namespace, name, objects)
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
      rdf = String.new
      
      XmlRdfBuilder.open(:target => rdf, :indent => 2) do |builder|
        builder.write_source(self)
      end
      
      rdf
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
    
    # Separates given attributes distinguishing between ActiveSource and RDF.
    def extract_attributes!(attributes)
      active_source_attributes = attributes.inject({}) do |active_source_attributes, column_values|
        active_source_attributes[column_values.first] = attributes.delete(column_values.first) if self.class.column_names.include? column_values.first
        active_source_attributes
      end

      [ active_source_attributes, attributes ]
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
        Source.new(name_or_uri)
      else
        Source.find_or_instantiate_by_uri(normalize_uri(attributes['uri']), name_or_uri)
      end
    end

    # Iterate through grouped_predicates_attributes, yielding the given code.
    def each_predicate(&block)
      grouped_predicates_attributes.each do |namespace, predicates|
        predicates.each do |predicate, objects|
          block.call(namespace, predicate, objects.flatten)
        end
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
    
  end
end
