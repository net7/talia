# Rake tasks for the discovery app
$: << File.join('vendor', 'plugins', 'talia_core', 'lib')

require 'rake'
require 'talia_util'

include TaliaUtil

namespace :discovery_app do
  
  desc "Init for this tasks"
  task :disco_init => 'talia_core:talia_init' do
    Dependencies.load_paths << File.join(File.dirname(__FILE__), '..', '..', 'app', 'models')
    TaliaCore::FacsimileEdition
    TaliaCore::CriticalEdition
  end
  
  # creates a facsimile edition
  desc "Creates an empty Facsimile Edition. Options nick=<nick> name=<full_name> description=<short_description>"
  task  :create_facsimile_edition => 'disco_init' do
        
    puts ENV['nick']    
    puts ENV['name']
    puts ENV['description']
        
    fe = TaliaCore::FacsimileEdition.new(N::LOCAL + ENV['nick'])
    fe.hyper::title << ENV['name']
    fe.hyper::description << ENV['description']
    fe.save!
  end
  
  desc "Creates a Facsimile Edition with all the available color facsimiles. Options nick=<nick> name=<full_name> description=<short_description>"
  task :create_color_facsimile_edition => 'create_facsimile_edition' do

    fe = TaliaCore::FacsimileEdition.find(N::LOCAL + ENV['nick'])
 
    joins = "JOIN semantic_relations SR ON (`active_sources`.`id` = SR.subject_id AND SR.object_type = 'TaliaCore::ActiveSource' AND SR.predicate_uri = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type') JOIN active_sources AcS2 ON (SR.object_id = AcS2.id AND AcS2.uri = 'http://www.hypernietzsche.org/ontology/Facsimile')"
    conditions = "`active_sources`.`id` in ( select AcS3.id from active_sources AcS3 JOIN semantic_relations SR2 ON (AcS3.id = SR2.subject_id AND SR2.object_type = 'TaliaCore::ActiveSource' AND SR2.predicate_uri = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type') JOIN active_sources AcS4 ON (SR2.object_id = AcS4.id AND AcS4.uri = 'http://www.hypernietzsche.org/ontology/Color'))"    

    color_facsimile = TaliaCore::Source.find(:all, :joins => joins, :conditions => conditions)
    
    color_facsimile.each do |cf|
      puts "adding #{cf.uri}"
      fe.add(cf.uri)
    end
  end
  
end