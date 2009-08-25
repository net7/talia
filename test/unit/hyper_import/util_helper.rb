require 'rexml/document'
require 'fileutils'
require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

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
      run_in_data_dir do
        uri = HyperImporter::Importer.import(xml)
        HyperImporter::Importer.write_imported!
        TaliaCore::ActiveSource.find(:first, :conditions => { :uri => uri })
      end
    end
    
    def data_record_files
      return [] # ['1', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13']
    end
    
    # Deletes the data files for the temp sources
    def clean_data_files
      puts "Cleaning #{TaliaCore::CONFIG["data_directory_location"]}"
      clean_data(TaliaCore::CONFIG["data_directory_location"])
    end

    # Cleans the databases and the caches of the import classes
    def clean_all_with_caches
      Util.flush_rdf
      Util.flush_db
      HyperImporter::Importer.type_cache.clear
      HyperImporter::SourceCache.cache.clear
      HyperImporter::SourceHash.hash.clear
    end

    # Clear the system for an import test
    def flush_once_for_import_test
      setup_once(:flush) do
        clean_data_files
        clean_all_with_caches
        true
      end
    end

    # Recursive cleaner for data files
    def clean_data(directory)
      # Break for the "dot" directory labels
      return if(File.basename(directory) =~ /^\..*/)
      if(FileTest.file?(directory) && !(File.basename(directory) =~ /temp.*/) && !(data_record_files.include?(File.basename(directory))))
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
