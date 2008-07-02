require 'rexml/document'
require 'fileutils'
require File.join(File.dirname(__FILE__), '..', 'test_helper')

module TaliaUtil
  module UtilTestMethods
    
    UTIL_PATH = File.expand_path(File.dirname(__FILE__))
    
    # Loads a test document
    def load_doc(name)
      name = URI.escape(name)
      demo_docs ||= {}
      demo_docs[name] ||= begin
        REXML::Document.new(File.open(File.join(UTIL_PATH, 'import_samples', "#{name}.xml")))
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
    
    # This is used to run the given block inside an environment inside the "data"
    # directory, but do not disturb the setting for the whole test application.
    # (The problem being that File.expand_path works on the current Dir, and changes
    # behaviour)
    def run_in_data_dir
      dir = File.expand_path(FileUtils.pwd)
      FileUtils.cd(File.join(UTIL_PATH, 'import_samples'))
      result = yield
      FileUtils.cd(dir) # restore the dir
      result
    end
    
    # Runs the hyper import inside the data dir (so that connected files are loaded correctly)
    def hyper_import(xml)
      run_in_data_dir { HyperImporter::Importer.import(xml) }
    end
    
    # Checks if the given property has the values given to this assertion. If
    # a value is an N::URI, this will assert if the property refers to the 
    # Source given by the URI.
    def assert_property(property, *values)
      assert_kind_of(PropertyList, property) # Just to be sure
      assert_equal(values.size, property.size, "Expected #{values.size} values instead of #{property.size}")
      values = values.collect { |value| value.is_a?(N::URI) ? TaliaCore::Source.new(value) : value }
      property.each do |value|
        assert(values.include?(value), "Found unexpected value #{value}. Value is a #{value.class}") 
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
        # delete all empty directory
        if (Dir.entries(directory)-['.','..']).empty?
          FileUtils.rmdir directory
        end
      end
    end
    
  end
end
