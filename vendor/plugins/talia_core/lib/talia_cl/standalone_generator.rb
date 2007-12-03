require 'ftools'
require 'fileutils'

# This is used to create a skeleton directory with the necessary
# files to set up a standalone Talia application.
module TaliaCl
  
  # Create a standalone installation directory for Talia
  def create_standalone(directory)
    if(File.exist?(directory))
      puts "The target directory already exists: #{directory}"
      return -1
    end
    
    begin
      puts("Creating Talia standalone in #{directory}")
      File.makedirs(directory)

      # copy the config diroectory
      File.makedirs(File.join(directory, "config"))
      copy_template(directory, "config", "database.yml")
      copy_template(directory, "config", "rdfstore.yml")
      copy_template(directory, "config", "talia_core.yml")
    rescue
      puts "Error creating. Removing files."
      FileUtils.rm_rf(directory)
      raise
    end
  end
  
  protected
  
  # This goes to the root directory for the "shared" templates. (The ones
  # contained in the talia generators.
  def shared_template_root
    File.join(File.expand_path(File.dirname(__FILE__)), "..", "..", "generators", "talia", "templates")
  end
  
  # Copies a shared template
  def copy_template(targetdir, relative_path, name, target_name = nil)
    source = File.join(shared_template_root, relative_path, name)
    target_name = name unless(target_name)
    target = File.join(targetdir, relative_path, target_name)
    File.cp(source, target)
    puts "Copied #{File.join(relative_path, name)} to #{target_name}"
  end
  
end
