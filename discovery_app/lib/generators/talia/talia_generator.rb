# A generator for the database tables that the Talia core uses
class TaliaGenerator < Rails::Generator::Base
  
  # Initialize the generator
  def initialize(runtime_args, runtime_options = {})
    super
    usage if(args.empty?)
    @generator_root = File.expand_path(File.dirname(__FILE__))
    @destination_root = args.shift
  end
  
  def manifest
    # Add the migrations
    record do |m|
      # root directory
      m.directory ""

     process_dir(m, 'app')
     process_dir(m, 'db')
     process_dir(m, 'public')
     process_dir(m, 'script')
     
      # Create the config directory
      m.directory('config')
      process_dir(m, File.join('config', 'environments'))
      m.file(talia_root(File.join('config', 'boot.rb')), File.join('config', 'boot.rb'))
      m.file(talia_root(File.join('config', 'environment.rb')), File.join('config', 'environment.rb'))
      m.file(talia_root(File.join('config', 'routes.rb')), File.join('config', 'routes.rb'))
      m.file(talia_root(File.join('config', 'database.yml.app_example')), File.join('config', 'database.yml'))
      m.file(talia_root(File.join('config', 'rdfstore.yml.app_example')), File.join('config', 'rdfstore.yml'))
      m.file(talia_root(File.join('config', 'talia_core.yml.app_example')), File.join('config', 'talia_core.yml'))
      
      # Root-level files
      m.file(talia_root('Rakefile'), 'Rakefile')
      
      # Create empty directories
      m.directory('log')
      m.directory('data')
      m.directory('vendor')
      m.directory(File.join('vendor', 'plugins'))
      
    end
  end
  
  protected

  # Use to copy a whole directory from the "template" to the new
  # talia instance
  def process_dir(manifest, directory, options = {})
    manifest.directory(directory)
    
    files = relative_dir_files(directory)
    
    process_files(manifest, files, options)
  end
    
  # Record a list of given file copies. The file_list should contain relative
  # pathnames from the talia root directory.
  def process_files(manifest, file_list, options = {})
    file_list.each do |file|
      if(File.directory?(file_root(file)))
        manifest.directory(file)
      else
        manifest.file(talia_root(file), file, options)
      end
    end
  end
  
  # Get the contents of a a directory as relative pathnames (without the 
  # root dir prepended)
  def relative_dir_files(directory)
    files = Dir["#{file_root(directory)}/**/*"]
    files.map! { |file| file.gsub(/#{file_root}/, '') }
  end
  
  # Change the given path so that it will point to the root of the "template"
  # installation
  def talia_root(path = '')
    File.join('..', '..', '..', '..', path)
  end
  
  # Get the absolute file path to the root of the "template" installation
  def file_root(path = '')
    File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', path))
  end
end
