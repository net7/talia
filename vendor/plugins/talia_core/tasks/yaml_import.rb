require 'rubygems'
gem 'progressbar'
require 'progressbar'

require 'lib/talia_core'
include TaliaCore

# Imports data for Talia from a yaml file
datafile = ARGV.size > 0 ? ARGV[0] : "data.yml"
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
  rdfconfig[environment][:new] = "yes"
  config["rdf_connection"] = rdfconfig[environment]
  
  # standalone database used
  config["standalone_db"] = true
  
  # Configuration for standalone database connection
  dbconfig = YAML::load(File.open(File.dirname(__FILE__) + '/../config/database.yml')) 
  config["db_connection"] = dbconfig[environment]
end

puts "System init complete"

[ 'source_records', 'dirty_relation_records', 'type_records', 'data_records'].reverse.each { |f| ActiveRecord::Base.connection.execute "DELETE FROM #{f}" }
puts "All database records deleted"

to_delete = Query.new.select(:s, :p, :o).where(:s, :p, :o).execute
to_delete.each do |s, p, o|
  FederationManager.delete(s, p, o)
end
puts "All RDF records deleted"

data = YAML::load(File.open(datafile))

if(data["namespaces"])
  data["namespaces"].each do |shortcut, uri|
    N::Namespace.shortcut(shortcut, uri)
    puts "Registered namespace #{shortcut} for #{uri}"
  end
  data.delete("namespaces")
end

progress = ProgressBar.new("Importing", data.size)

puts "Importing data..."

data.each do |source_name, data_set|
  
  workflow_state = data_set["workflow_state"] ? data_set.delete("workflow_state").to_i : 0
  primary_source = data_set.delete("primary_source") == "true" ? true : false
  types = data_set.delete("type")
  types = [types] unless(types.kind_of?(Array))
  types.compact!
  # Create the type uris
  types = types.collect { |type| make_uri(type) }
  
  # Create the source
  source = Source.new(source_name, *types)
  source.workflow_state = workflow_state
  source.primary_source = primary_source
  source.save! # save the thing
  
  # Now add the rdf elements
  data_set.each do |name, value|
    uri = make_uri(name, "#")
    value = [value] unless(value.kind_of?(Array))
    
    value.each do |val|
      val = Source.new(make_uri(val)) if(val.index(":"))
      source[uri] << val
    end
  end
  
  source.save! # Save all
  
  progress.inc
end

progress.finish
puts "Done"
