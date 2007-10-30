require 'rubygems'
gem 'progressbar'
require 'progressbar'

require 'lib/talia_core'
include TaliaCore

# Imports data for Talia from a yaml file
datadir = ARGV.size > 0 ? ARGV[0] : "data/"
environment = ARGV.size > 1 ? ARGV[1] : "development"

# Get an URI string from the given string in ns:name notation
def make_uri(str, separator = ":")
  type = str.split(separator)
  type = [type[1]] if(type[0] == "")
  if(type.size == 2)
    N::URI[type[0]] + type[1]
  else
    N::LOCAL + type[0]
  end
end


TaliaCore::Initializer.run do |config|
  
  # The name of the local node
  config["local_uri"] = "http://www.talia.discovery-project.org/sources/"
  
  # The "default" namespace
  config["default_namespace_uri"] = "http://www.talia.discovery-project.org/sources/default/"
  
  # Connect options for ActiveRDF
  rdfconfig = YAML::load(File.open(File.dirname(__FILE__) + '/../config/rdfstore.yml'))
  config["rdf_connection"] = rdfconfig[environment]
  
  # standalone database used
  config["standalone_db"] = true
  
  # Configuration for standalone database connection
  dbconfig = YAML::load(File.open(File.dirname(__FILE__) + '/../config/database.yml')) 
  config["db_connection"] = dbconfig[environment]
end


puts "System init complete"

progress = ProgressBar.new("Importing", Dir.entries(datadir).size)
not_found = []

Dir["#{datadir}/*"].each do |file|
  name = File.basename(file)
  if(Source.exists?(name))
    src = Source.find(name)
    if(src.data_records.size == 0)
      data = SimpleText.new
      data.location = name
      src.data_records << data
      src.save!
      data.save!
    end
  else
    not_found << file
  end
  progress.inc
end

progress.finish
puts "Done, #{not_found.size} of #{Dir.entries(datadir).size} files had no record associated."
not_found.each { |file| puts file}
