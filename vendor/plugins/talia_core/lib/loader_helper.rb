require "rubygems"

# Some helpers for the Talia bootstrapping (when the module is loaded)
module TLoad

  # This tries to load the the given module. 
  # It first attempts to load from local_path/lib/local_name
  # The local path is always appended to the directory of the script
  # currently running.
  # If that fails, it tries to load the given gem
  def self.require_module(gem_name, local_name, local_path)
    begin
      # Try to loaTad from local
      $:.unshift(File.dirname(__FILE__) + local_path + "/lib")  
      require local_name  
    rescue LoadError
      require 'rubygems'
      gem gem_name
      require local_name
    end
  end

end