# Create the commands for the Talia console
require 'console_commands'

module TaliaCommandLine
  
  desc "Show help on the talia console commands"
  console(:thelp) do
    puts "Talia console commands:\n\n"
    TaliaCommandLine::console_commands.each do |command|
      puts "#{command[0]}\t- #{command[1]}"
    end
   nil
  end

  desc "Get all sources"
  console(:sources) do
    TaliaCore::Source.find(:all)
  end

  desc "Find a source by local uri"
  console(:tsrc) do |uri|
    TaliaCore::Source.find(N::LOCAL + uri)
  end

  desc "Add a RDF source adapter. Result set to 'adapter'. Use: :type, option => ..."
  console(:rdf_source) do |type, options|
    options[:type] = type
    to_var :adapter, ConnectionPool.add_data_source(options)
  end

  desc "Drop RDF data sources."
  console(:rdf_down) do
    ConnectionPool.clear
  end

  desc "Create a RDFS::Resource. Result set to 'res'"
  console(:resource) do |uri|
    to_var :res, RDFS::Resource.new(uri)
  end

  desc "Print the given element"
  console(:tprint) do |element|
    puts element.class
    if(element.kind_of?(TaliaCore::Source))
      puts "Source: #{element.uri}"
      puts "Name:   #{element.name}m"
      element.direct_predicates.each do |pred|
        puts "#{pred.to_name_s}:"
        pred.each { |val| puts val}
      end
    elsif(element.kind_of?(RDFS::Resource))
      puts "RDFS::Resource #{element.uri}"
      element.direct_predicates.each do |pred|
        puts "#{pred.uri}:"
        element[pred.uri].each { |val| puts "\t#{Uri.new(val).to_name_s}\n\n" }
      end
    elsif(element.kind_of?(String))
      puts element
    elsif(element.respond_to?("each"))
      element.each { |el| puts el.to_s }
    else
      puts "Unknown type: #{element.class}"
    end
    nil
  end

  desc "Print the rdf types"
  console(:put_types) do 
    N::SourceClass.rdf_types.each do |type|
      puts type.to_name_s
    end
    nil
  end

  desc "Import into the Talia store. Can be called with {rdf|data|yaml} as parameter"
  console(:talia_import) do |type|
    unless(type)
      print "Import which type? (rdf|data|yaml) : "
      type = readline
    end
    type = type.to_s.strip
    print "Enter file pattern: "
    filepattern = readline
    case(type)
    when "rdf":
      print "Select data file format (ntriples|rdfxml): "
      dataformat = readline
      RdfImport::import(dataformat, FileList.new(filepattern))
    when "yaml":
      YamlImport::import_multi_files(FileList.new(filepattern))
    when "data":
      print "Select data type to import: "
      datatype = readline
      DataImport::import(FileList.new(filepattern), datatype)
    end
  end

  desc "Quick query for sources. Use nil as a placeholder"
  console(:tquery) do |subject, predicate, object|
    variables = []
    q_subject = if(subject)
      RDFS::Resource.new(make_uri(subject).to_s)
    else
      variables << :s
      :s
    end
    q_predicate = if(predicate)
      RDFS::Resource.new(make_uri(predicate).to_s)
    else
      variables << :p
      :p
    end
    q_object = if(object)
      if(object.include?(":"))
        RDFS::Resource.new(make_uri(object).to_s)
      else
        object
      end
    else
      variables << :o
      :o
    end
    my_query = Query.new.select(*variables).distinct
    my_query.where(q_subject, q_predicate, q_object)
    puts "SPARQL: #{Query2SPARQL.translate(my_query)}"
    puts ""
    my_query.execute
  end
end


