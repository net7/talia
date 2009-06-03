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

      # Get the configured folder for the ontologies
      def ontology_folder
        ENV['ontology_folder'] || File.join(RAILS_ROOT, 'ontologies')
      end

      # Set up the ontologies from the given folder
      def setup_ontologies
        # Clear the ontologies from RDF, if possible
        if((adapter = ConnectionPool.write_adapter).supports_context?)
          adapter.clear(N::URI.new(N::LOCAL + 'ontology_space'))
        else
          puts "WARNING: Cannot remove old ontologies, adapter doesn't support contexts."
        end

        puts "Ontologies loaded from: #{ontology_folder}"
        files = Dir[File.join(ontology_folder, '*.{rdf*,owl}')]
        ENV['rdf_syntax'] ||= 'rdfxml'
        RdfImport::import(ENV['rdf_syntax'], files)
        RdfUpdate::owl_to_rdfs
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
        if(flag?('reset_db'))
          flush_db
          puts "DB flushed"
        end
    
        # Flus the rdf if requested
        if(flag?('reset_rdf'))
          flush_rdf
          puts "RDF flushed"
        end
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
  
      # Flush the database. This only flushes the main data tables!
      def flush_db
        [ 'active_sources', 'data_records', 'semantic_properties', 'semantic_relations'].reverse.each { |f| ActiveRecord::Base.connection.execute "DELETE FROM #{f}" }
      end
  
      # Flush the RDF store
      def flush_rdf
        ConnectionPool.write_adapter.clear
      end

      # Rewrite the RDF for the whole database. Will yield without parameters
      # for progress-reporting blocks.
      # FIXME: At the moment, this
      # looses all RDF data that is not in the database.
      def rewrite_rdf
        flush_rdf
        # We'll get all data from single query.
        fat_rels = TaliaCore::SemanticRelation.find(:all, :joins => fat_record_joins,
          :select => fat_record_select)
        fat_rels.each do |rec|
          subject = N::URI.new(rec.subject_uri)
          predicate = N::URI.new(rec.predicate_uri)
          object = if(rec.object_uri)
            N::URI.new(rec.object_uri)
          else
            rec.property_value
          end
          FederationManager.add(subject, predicate, object)
          yield if(block_given?)
        end

        # Rewriting all the "runtime type" rdf triples
        # We'll select the type as something else, so that it doesn't try to do
        # STI instantiation (which would cause this to blow for classes that
        # are defined outside the core.
        TaliaCore::ActiveSource.find(:all, :select => 'uri, type AS runtime_type').each do |src|
          type = (src.runtime_type || 'ActiveSource')
          FederationManager.add(src, N::RDF.type, N::TALIA + type)
          yield if(block_given?)
        end
      end

      # This gives the number of triples that would be rewritten on #rewrite_rdf
      def rewrite_count
        TaliaCore::SemanticRelation.count + TaliaCore::ActiveSource.count
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

      # For selecting "fat" records on the semantic properties, including the
      # objects. Used for rewriting the rdf. TODO: Review after merging
      # with optimized branch
      def fat_record_select
        select = 'semantic_relations.id AS id, semantic_relations.created_at AS created_at, '
        select << 'semantic_relations.updated_at AS updated_at, '
        select << 'object_id, object_type, subject_id, predicate_uri, '
        select << 'obj_props.created_at AS property_created_at, '
        select << 'obj_props.updated_at AS property_updated_at, '
        select << 'obj_props.value AS property_value, '
        select << 'obj_sources.created_at AS object_created_at, '
        select << 'obj_sources.updated_at AS object_updated_at, obj_sources.type AS  object_realtype, '
        select << 'obj_sources.uri AS object_uri, '
        select << 'subject_sources.uri AS subject_uri'
        select
      end

      # Select semantic properties joined with all connected tables.
      # TODO: Review after merging with optimized branch
      def fat_record_joins
        joins =  " LEFT JOIN active_sources AS obj_sources ON semantic_relations.object_id = obj_sources.id AND semantic_relations.object_type = 'TaliaCore::ActiveSource'"
        joins << " LEFT JOIN semantic_properties AS obj_props ON semantic_relations.object_id = obj_props.id AND semantic_relations.object_type = 'TaliaCore::SemanticProperty'"
        joins << " LEFT JOIN active_sources AS subject_sources ON semantic_relations.subject_id = subject_sources.id"
        joins
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