require 'rubygems'
gem 'optiflag'
require 'optiflag'

# Parse for the command line
module TaliaCommands extend OptiFlagSet
  
  and_process!
end
