require 'rexml/document'
require File.join(File.dirname(__FILE__), '..', 'test_helper')

module TaliaUtil
  module UtilTestMethods
    
    # Loads a test document
    def load_doc(name)
      demo_docs ||= {}
      demo_docs[name] ||= begin
        current_dir = File.expand_path(File.dirname(__FILE__))
        REXML::Document.new(File.open(File.join(current_dir, 'import_samples', "#{name}.xml")))
      end
      demo_docs[name]
    end
    
    # Test the types of an element. Asserts if the source has the same types as
    # given in the types argument(s)
    def assert_types(source, *types)
      assert_kind_of(TaliaCore::Source, source) # Just to be sure
      type_list = ""
      source.types.each { |type| type_list << "#{type.local_name}\n" }
      assert_equal(types.size, source.types.size, "Type size mismatch: Source has #{source.types.size} instead of #{types.size}.\n#{type_list}")
      types.each { |type| assert(source.types.include?(type), "#{source.uri.loca_name} should have type #{type}\n#{type_list}") }
    end
    
    # Checks if the given property has the values given to this assertion. If
    # a value is an N::URI, this will assert if the property refers to the 
    # Source given by the URI.
    def assert_property(property, *values)
      assert_kind_of(PropertyList, property) # Just to be sure
      assert_equal(values.size, property.size, "Expected #{values.size} values instead of #{property.size}")
      values = values.collect { |value| value.is_a?(N::URI) ? TaliaCore::Source.new(value) : value }
      property.each do |value|
        assert(values.include?(value), "Found unexpexcted value #{value}. Value is a #{value.class}") 
      end
    end
    
    # Deletes the data files for the temp sources
    def clean_data_files
      puts "Cleaning #{TaliaCore::CONFIG["data_directory_location"]}"
      clean_data(TaliaCore::CONFIG["data_directory_location"])
    end
    
    # Recursive cleaner for data files
    def clean_data(directory)
      # Break for the "dot" directory labels
      return if(File.basename(directory) =~ /^\..*/)
      if(FileTest.file?(directory) && !(File.basename(directory) =~ /temp.*/))
        File.delete(directory)
        puts "#{directory} ...deleted"
      elsif(FileTest.directory?(directory))
        Dir.entries(directory).each { |entry| clean_data(File.join(directory, entry)) }
      end
    end
    
  end
end
