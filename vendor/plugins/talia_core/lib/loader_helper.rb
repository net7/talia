require 'rubygems'

# Some helpers for the Talia bootstrapping (when the module is loaded)
module TLoad

  # This tries to load the the given module. 
  # It first attempts to load from local_path/lib/local_name
  # The local path is always appended to the directory of the script
  # currently running.
  # If that fails, it tries to load the given gem
  def self.require_module(gem_name, local_name, local_path, gem_version = nil)
    begin
      # Try to loaTad from local if it exists
      search_dir = File.join(File.dirname(__FILE__), local_path, "lib")
      if(File.exists?(search_dir))
        puts "FOUND local: #{search_dir}"
        $:.unshift(search_dir)  
        require local_name  
      else
        puts "NOT FOUND #{search_dir}"
        load_from_gem(gem_name, local_name, gem_version)
      end
    rescue LoadError
      load_from_gem(gem_name, local_name, gem_version)
    end
  end
  
  private
  
  def self.load_from_gem(gem_name, local_name, gem_version)
    puts "MEEP"
    puts "Loading #{local_name} from #{gem_name} v. #{gem_version}"
    gem gem_name, gem_version
    require local_name
  end

end