# Utility module for tests, rake tasks etc.
module TaliaUtil
  
  # Main utility functions for Talia
  class Util
    class << self
    
      # Get the list of files from the "files" option
      def get_files
        puts "Files given: #{ENV['files']}"
        unless(ENV['files'])
          puts("This task needs files to work. Pass them like this files='something/*.x'")
          print_options
          exit(1)
        end
    
        FileList.new(ENV['files'])
      end

      # Init the talia core system
      def init_talia
        return if(TaliaCore::Initializer.initialized)
    
        # If options are not set, the initializer will fall back to the internal default
        TaliaCore::Initializer.talia_root = ENV['talia_root']
        TaliaCore::Initializer.environment = ENV['environment']
    
        config_file = ENV['config'] ? ENV['config'] : 'talia_core'
    
        # run the initializer
        TaliaCore::Initializer.run(config_file) do |config|
          unless(flag?('no_standalone'))
            puts "Always using standalone db from utilities."
            puts "Give the no_standalone option to override it."
            config['standalone_db'] = "true"
          end
        end
    
        puts("\nTaliaCore initialized")
    
        # # Flush the database if requested
        flush_db if(flag?('reset_db'))
    
        # Flus the rdf if requested
        flush_rdf if(flag?('reset_rdf'))
      end
  
      # Get info from the Talia configuraion
      def talia_config
        puts "Talia configuration"
        puts ""
        puts "TALIA_ROOT: #{TALIA_ROOT}"
        puts "Environment: #{TaliaCore::CONFIG['environment']}"
        puts "Standalone DB: #{TaliaCore::CONFIG['standalone_db']}"
        puts "Data Directory: #{TaliaCore::CONFIG['data_directory_location']}"
        puts "Local Domain: #{N::LOCAL}"
      end
  
      # Put the title for Talia
      def title
        puts "\nTalia Digital Library system. Version: #{TaliaCore::Version::STRING}" 
        puts "http://www.talia.discovery-project.eu/\n\n"
      end
  
      # Flush the database
      def flush_db
        [ 'active_sources', 'data_records'].reverse.each { |f| ActiveRecord::Base.connection.execute "DELETE FROM #{f}" }
        puts "All database records deleted"
      end
  
      # Flush the RDF store
      def flush_rdf
        to_delete = Query.new.select(:s, :p, :o).where(:s, :p, :o).execute
        to_delete.each do |s, p, o|
          FederationManager.delete(s, p, o)
        end
        puts "All RDF records deleted"
      end
  
      # Load the fixtures
      def load_fixtures
        # fixtures = ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(File.dirname(__FILE__), 'test', 'fixtures', '*.{yml,csv}'))  
        fixtures = [ 'active_sources', 'semantic_relations', 'semantic_properties' 'data_records']
        fixtures.reverse.each { |f| ActiveRecord::Base.connection.execute "DELETE FROM #{f}" }
        fixtures.each do |fixture_file|
          Fixtures.create_fixtures(File.join('test', 'fixtures'), File.basename(fixture_file, '.*'))  
        end  
      end
  
      # Do migrations
      def do_migrations
        migration_path = File.join("generators", "talia", "templates", "migrations")
        ActiveRecord::Migrator.migrate(migration_path, ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
      end
  
      # Check if the given flag is set on the command line
      def flag?(the_flag)
        assit_not_nil(the_flag)
        ENV[the_flag] && (ENV[the_flag] == "yes" || ENV[the_flag] == "true")
      end
  
      # print the common options for the tasks
      def print_options
        puts "\nGeneral options (not all options are valid for all tasks):"
        puts "files=<pattern>     - Files for the task (a pattern to match the files)"
        puts "talia_root=<path>   - Manually configure the TALIA_ROOT path"
        puts "                      (default:autodetect)"
        puts "reset_rdf={yes|no}  - Flush the RDF store (default:no)"
        puts "reset_db={yes|no}   - Flush the database (default:no)"
        puts "config=<filename>   - Talia configuration file (default: talia_core)"
        puts "environment=<env>   - Environment for configuration (default: development)"
        puts "data_dir=<dir>      - Directory for the data files"
        puts "verbose={yes|no}    - Show some additional info"
        puts ""
      end
  
    end
  end
end