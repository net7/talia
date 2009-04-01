require 'ftools'
require 'fileutils'

# This is used to create a skeleton directory with the necessary
# files to set up a standalone Talia application.
module TaliaCommandLine
  
  class << self
  
    # Create a standalone installation directory for Talia
    def create_standalone(directory)
      if(File.exist?(directory))
        puts "The target directory already exists: #{directory}"
        return -1
      end

      begin
        puts("Creating Talia standalone in #{directory}")
        File.makedirs(directory)

        # Copy the rake task extensions
        copy_dir(directory, "tasks")
        
        # Copy the rakefile
        copy_file(directory, "", File.join('standalone_templates', 'Rakefile'), 'Rakefile')
        
        # copy the config directory
        File.makedirs(File.join(directory, "config"))
        copy_file(directory, "config", "database.yml.example", "database.yml")
        copy_file(directory, "config", "r„dfstore.yml.redland_example", "rdfstore.yml")
        copy_file(directory, "config", "talia_core.yml.example", "talia_core.yml")
      rescue
        puts "Error creating. Removing files."
        FileUtils.rm_rf(directory)
        raise
      end
    end

    protected


    # This goes to the root directory for the "shared" templates. (The ones
    # contained in the talia generators.
    def core_root
      File.join(File.expand_path(File.dirname(__FILE__)), "..", "..", "..", "..")
    end
    

    # Recursively copies a directory of template files.
    def copy_dir(targetdir, dirname)
      puts "Processing directory #{dirname}"
      targetdir = dirname unless(targetdir)
      File.makedirs(File.join(targetdir, dirname))
      Dir["#{File.join(core_root, dirname)}/**"].each do |file|
        unless(file =~ /^\..*/) # exclude hidden/directory files
          if(File.directory?(file))
            copy_dir(targetdir, File.join(dirname, File.basename(file)))
          else
            copy_file(targetdir, dirname, File.basename(file))
          end
        end
      end
    end
    
    # Copies a file to the new target directory in the given path
    def copy_file(targetdir, relative_path, name, target_name = nil)
      source = File.join(core_root, relative_path, name)
      target_name = name unless(target_name)
      target = File.join(targetdir, relative_path, target_name)
      File.cp(source, target)
      puts "Copied #{File.join(relative_path, name)} to #{target_name}"
    end
  
  end
end
