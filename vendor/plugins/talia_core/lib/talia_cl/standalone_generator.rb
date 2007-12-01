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
    
    FileUtil.makedirs(directory)
    
  end
end
