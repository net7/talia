require 'rexml/document'

module TaliaUtil
  
  module HyperImporter
    
    DEFAULT_WORKFLOW_STATE = 0
    
    # Superclass for import modules of Hyper data imports
    class Importer
      
      # Creates a new importer, using the given element to initialize it. This
      # reads the information from the xml element into the object.
      def initialize(element_xml)
        check_namespaces!
        @element_xml = element_xml
        source_name = get_text(element_xml, "siglum")
        assit(source_name && source_name != "", "Source with no name!")
        if(source_name && source_name != "")
          @source = get_source(source_name, *get_source_types)
          @source.primary_source = primary_source?
          @source.workflow_state = DEFAULT_WORKFLOW_STATE
        end
        @source.save!
      end
      
      # Imports the data. To be overwritten by child classes
      def import!
        assit_fail("Should never call base class version of import.")
      end
      
      # Get the source that was imported by this importer.
      def source
        @source
      end
      
      # This is called to do the actual import. It will take the XML Element
      # of the element to be imported and return a new Source object
      def self.import(element_xml)
        assit_real_string(element_xml.root.name, "XML root element must have a name")
        importer = importer_for_element(element_xml.root)
        importer.import!
        importer.source
      end
      
      protected
      
      # Gets the importer for a given element name
      def self.importer_for_element(element)
        begin
          klass = TaliaUtil::HyperImporter.const_get("#{element.name.capitalize}Importer")
          assit_kind_of(Class, klass, "Could not create a class from #{element.name}")
          klass.new(element)
        rescue RuntimeError => e
          assit_fail("Exception during import: #{e}")
        end
      end
      
      # Gets the content of an element as a string. This looks for the direct
      # child of the root element with the given name, and returns the text
      # contained in that element - if any.
      def get_text(root, name)
        if(node = root.elements[name])
          node.text.strip if(node.text)
        end
      end
      
      
      # Gets or creates the Source with the given name. If the Source already
      # exists, it will add the given types to it
      def get_source(source_name, *types)
        source_uri = N::HY_NIETZSCHE + source_name
        src = nil
        if(TaliaCore::Source.exists?(source_uri))
          # If the Source already exists, push the types in
          src = TaliaCore::Source.new(N::HY_NIETZSCHE + source_name)
          type_list = src.types
          assit_equal(type_list.size, 0, "There should not be types here.")
          types.each do |type|
            type_list << type
          end
        else
          src = TaliaCore::Source.new(N::HY_NIETZSCHE + source_name, *types)
        end
        
        assit_kind_of(TaliaCore::Source, src)
        src
      end
      
      # Reads all the relations on a Source that are given in the "relations"
      # element.
      def import_relations!
        @element_xml.root.elements.each("relations/relation") do |rel|
          # Add each relation with predicate and object
          begin
            predicate = rel.elements["predicate"].text.strip
            object = rel.elements["object"].text.strip
            assit_real_string(predicate, "Predicate missing. Object: #{object}")
            assit_real_string(object, "Object missing. Predicate: #{predicate}")
            # Now we need to create/get the source for the relation,
            # and assign it to the current source
            object_source = TaliaCore::Source.new(N::HY_NITZSCHE + object)
            object_source.save!
            @source[N::HY_NIETZSCHE + predicate] << object_source
          rescue RuntimeError => e
            assit_fail("Error during relation import, possibly malformed XML?")
          end
        end
      end
      
      # Checks for the hy_nietzsche namespace, which must be defined for the
      # import to work
      def check_namespaces!
        check_namespace!(:HY_NIETZSCHE)
        check_namespace!(:DCNS)
      end
      
      # Checks a single namespace. Helper for check_namspaces.
      def check_namespace!(namespace)
        namespace = namespace.to_s.upcase
        unless(N.const_defined?(namespace))
          raise(RuntimeError, "ATTENTION: Namespace #{namespace} must be defined for the import to work.")
        end   
      end
      
      # Helper to set the Source type(s) for the importer. These can be 
      # strings or N::URI objects.
      #
      # This can be used in the class definition of the importer like:
      # <tt>source_types N::HY_NIETZSCHE::book</tt>
      def source_types(*types)
        # Assert that this is not called on the supertype. Due to the
        # handling of class variables in ruby this would break the mechanism.
        assit(self.class != Importer, "Must never call this method on superclass.")
        if(types.size == 0 || types[0] == :none)
          @@source_types = nil
        else
          @@source_types = types
        end
      end
    
      alias source_type source_types
      
      # Get the Source type configured for the the importer
      def get_source_types
        if(defined?(@@source_types))
          @@source_types
        else
          []
        end
      end
      
      # Helper to indicate that the importer is for a primary source type. 
      # This can be used in the importer subclass to "tag" the importer
      # as a primary source importer.
      #
      # You can use this in the importer class like <tt>primary_source true</tt>
      def primary_source(value = true)
        # Assert that this is not called on the supertype. Due to the
        # handling of class variables in ruby this would break the mechanism.
        assit(self.class != Importer, "Must never call this method on superclass.")
        @@primary_source = value
      end
      
      # Checks if this is a primary source
      def primary_source?
        if(defined?(@@primary_source))
          @@primary_source
        else
          false
        end
      end
      
    end
    
  end
end

# Require all the importer class files from this directory
# This automatically loads all files with importer classes
$: << File.expand_path(File.dirname(__FILE__))
Dir.entries(File.expand_path(File.dirname(__FILE__))).each do |file|
  if(file =~ /_importer\.rb$/)
    require file
  end
end
