# A generator for the database tables that the Talia core uses
class TaliaGenerator < Rails::Generator::Base
  
  # Initialize the generator
  def initialize(runtime_args, runtime_options = {})
    @migration_root = File.expand_path(File.dirname(__FILE__))
    super
  end
  
  def manifest
    # Add the migrations
    record do |m|
      # configuration files
      m.template(File.join("config", "talia_core.yml"), File.join("config", "talia_core.yml"))
      m.template(File.join("config", "rdfstore.yml"), File.join("config", "rdfstore.yml"))
      migration_templates(m)
    end
  end
  
  protected
  
  # Generate the migrations. We will use the numbering of the files present
  # in the migration directory, the numbering will be replaced with the 
  # "proper" numbering during the migration process.
  def migration_templates(manifest)
    # Regexp for the migration files. We consider only the files that
    # start with three numbers and an underscore
    mig_re = /^(\d\d\d)_(.*).rb$/
    migration_root = File.join(@migration_root, "templates", "migrations")
    # Hash the migrations
    migrations = {}
    Dir.entries(migration_root).each do |name|
      if((md = mig_re.match(name)) && !File.directory?(File.join(migration_root, name)))
        # Add the migration to the hash, with both the 
        # original name and the plain migration name
        migrations[md[1].to_i] = [name, md[2]]
      end
    end
    
    # Now go through the migrations we found and construct the templates
    migrations.keys.sort.each do |number|
      template = File.join("migrations", migrations[number][0])
      migration_name = migrations[number][1]
      manifest.migration_template(template, "db/migrate", :migration_file_name => migration_name )
    end
  end
end
