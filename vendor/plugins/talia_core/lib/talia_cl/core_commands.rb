# 
# Loads the commands that are defined for the talia core
#

command_dir = File.expand_path(File.join(File.dirname(__FILE__), 'commands'))

$: << command_dir

Dir["#{command_dir}/*.rb"].each do |file|
  require File.basename(file.gsub(/\.rb$/, ''))
end
