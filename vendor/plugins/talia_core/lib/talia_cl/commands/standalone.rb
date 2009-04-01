# Define the command for generating a standalone Talia application
module TaliaCommandLine
 
  desc "Generate a standalone application"
  command(:standalone) do
    # Loader file for the talia console
    $: << File.join(File.expand_path(File.dirname(__FILE__)), "standalone")
    
    require 'cl_options'
    require 'standalone_generate'
    
    directory = ARGV.shift
    
    unless(directory)
      puts("No directory given. Please use 'talia standalone <directory> [options]'")
      exit -1
    end
    
    # flags = TaliaCommands::flags
    
    create_standalone(directory)
  end

end

