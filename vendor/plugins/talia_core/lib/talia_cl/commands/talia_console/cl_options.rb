require 'rubygems'
gem 'optiflag'
require 'optiflag'

# Parse for the command line
module TaliaCommands extend OptiFlagSet
  
  optional_flag "talia_root" do
    description "Path to the TALIA_ROOT. (default: automatic)"
    one_arg
  end
  
  optional_flag "talia_config" do
    description "Talia configuration file name. (default: talia_core.yml)"
    one_arg
  end
  
  optional_flag "environment" do
    description "Environment for connections. (default: devlopement)"
    one_arg
  end
  
  optional_switch_flag "reset_db" do
    description "Reset the database"
  end
  
  optional_switch_flag "reset_rdf" do
    description "Reset the RDF store"
  end
  
  optional_switch_flag "verbose" do
    description "Turn on the verbose mode"
  end
  
  optional_switch_flag "noinit" do
    description "Do not initialize the Talia core"
  end
  
  and_process!
  
  # Putting the flags into the environment, and remove them to avoid 
  # having them interpreted by irb
  flags.each do |flag, content|
    my_content = content
    my_content = "yes" if(content == true)
    ENV[flag.to_s] = my_content
    killed = ARGV.index("-#{flag}") # Delete the flag
    if(killed)
      ARGV.delete_at(killed + 1) if(content.is_a?(String)) # delete the parameter, if there is one
      ARGV.delete_at(killed)
    end
  end
  
  # puts ENV.each { |k,v| puts "#{k} - #{v}"} if(flags[:verbose])
end
