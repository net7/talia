require 'rubygems'
gem 'progressbar'
require 'progressbar'

module TaliaUtil
  # Register the namespaces define in the data file
  def register_namespaces(data)
    if(data["namespaces"])
      data["namespaces"].each do |shortcut, uri|
        if(N::URI.shortcut_exists?(shortcut))
          if(!N::URI[shortcut].to_s == shortcut)
            puts "WARNING: Namespace for #{shortcut} already registered with #{N::URI[shortcut]} instead of #{uri}."
          else
            puts "Namespace #{shortcut} already registered."
          end
        else
          N::Namespace.shortcut(shortcut, uri)
          puts "Registered namespace #{shortcut} for #{uri}"
        end
      end
      data.delete("namespaces")
    end
  end

  def yaml_import(files)
    files.each do |file|
      yaml_file_import(file)
    end
  end

  # Import the data from a YAML file
  def yaml_file_import(datafile)
    data = YAML::load(File.open(datafile))

    register_namespaces(data)

    progress = ProgressBar.new("Importing", data.size)

    puts "Importing data from #{datafile}..."

    data.each do |source_name, data_set|

      workflow_state = data_set["workflow_state"] ? data_set.delete("workflow_state").to_i : 0
      primary_source = data_set.delete("primary_source") == "true" ? true : false
      types = data_set.delete("type")
      types = [types] unless(types.kind_of?(Array))
      types.compact!
      # Create the type uris
      types = types.collect { |type| make_uri(type) }

      # Create the source
      source = TaliaCore::Source.new(source_name, *types)
      source.workflow_state = workflow_state
      source.primary_source = primary_source
      source.save! # save the thing

      # Now add the rdf elements
      data_set.each do |name, value|
        uri = make_uri(name, "#")
        value = [value] unless(value.kind_of?(Array))

        value.each do |val|
          val = TaliaCore::Source.new(make_uri(val)) if(val.index(":"))
          source[uri] << val
        end
      end

      source.save! # Save all

      progress.inc
    end

    progress.finish
    puts "Done"
  end
end
  