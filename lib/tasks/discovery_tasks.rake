# Rake tasks for the discovery app
$: << File.join('vendor', 'plugins', 'talia_core', 'lib')

require 'rake'
require 'talia_util'

include TaliaUtil

namespace :discovery do
  
  desc "Init for this tasks"
  task :disco_init do # => 'talia_core:talia_init' do
    # Dependencies.load_paths << File.join(File.dirname(__FILE__), '..', '..', 'app', 'models')
    require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
    TaliaCore::FacsimileEdition
    TaliaCore::CriticalEdition
  end
  
  # Import from Hyper
  desc "Import data from Hyper. Options: base_url=<base_url> [list_path=?get_list=all] [doc_path=?get=] [extension=] [user=<username> password=<pass>]"
  task :hyper_import => :disco_init do
    HyperXmlImport::set_auth(ENV['user'], ENV['password'])
    HyperXmlImport::import(ENV['base_url'], ENV['list_path'], ENV['doc_path'], ENV['extension'])
  end
  
  # creates a facsimile edition
  desc "Creates an empty Facsimile Edition. Options nick=<nick> name=<full_name> description=<short_description>"
  task  :create_facsimile_edition => 'disco_init' do
    
    fe = TaliaCore::FacsimileEdition.new(N::LOCAL + ENV['nick'])
    fe.hyper::title << ENV['name']
    fe.hyper::description << ENV['description']
    fe.save!
  end
  
  # creates a facsimile edition and adds to it all the color facsimiles found in the DB
  desc "Creates a Facsimile Edition with all the available color facsimiles. Options nick=<nick> name=<full_name> description=<short_description>"
  task :create_color_facsimile_edition => 'create_facsimile_edition' do

    fe = TaliaCore::FacsimileEdition.find(N::LOCAL + ENV['nick'])

    qry = Query.new(N::Book).select(:b).distinct
    qry.where(:p, N::HYPER.part_of, :b)
    qry.where(:f, N::HYPER.manifestation_of, :p)
    qry.where(:f, N::RDFS.type, N::HPYER + 'Facsimile')
    qry.where(:f, N::RDFS.type, N::HYPER + 'Color')
    qry.execute.each do |book|
      fe.add_from_concordant(book, true)
      book.pages.each do |page|
        # here these pages have different URI and no relations to the "old" ones 
        # I've just retrieved with the query.
        #
        # this will not work, then:
        qry = Query.new(TaliaCore::Source).select(:f).distinct
        qry.where(:f, N::HYPER.manifestation_of, page)
        qry.where(:f, N::RDFS.type, N::HPYER + 'Facsimile')
        qry.where(:f, N::RDFS.type, N::HYPER + 'Color')
        #
      end
    end
    
    #but even with:
    # ( or a better query... )
    qry = Query.new(TaliaCore::Source).select(:p,:f).distinct 
    qry.where(:f, N::HYPER.manifestation_of, :p)
    qry.where(:f, N::RDFS.type, N::HPYER + 'Facsimile')
    qry.where(:f, N::RDFS.type, N::HYPER + 'Color')
    # how should I recognize the newly created pages corresponding to :p in the result ?    
     
    
    
    #        joins = "JOIN semantic_relations SR ON (`active_sources`.`id` = SR.subject_id AND SR.object_type = 'TaliaCore::ActiveSource' AND SR.predicate_uri = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type') JOIN active_sources AcS2 ON (SR.object_id = AcS2.id AND AcS2.uri = 'http://www.hypernietzsche.org/ontology/Facsimile')"
    #        conditions = "`active_sources`.`id` in ( select AcS3.id from active_sources AcS3 JOIN semantic_relations SR2 ON (AcS3.id = SR2.subject_id AND SR2.object_type = 'TaliaCore::ActiveSource' AND SR2.predicate_uri = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type') JOIN active_sources AcS4 ON (SR2.object_id = AcS4.id AND AcS4.uri = 'http://www.hypernietzsche.org/ontology/Color'))"    
    #    
    #        color_facsimile = TaliaCore::Source.find(:all, :joins => joins, :conditions => conditions)
    #        
    #        color_facsimile.each do |cf|
    #          puts "adding #{cf.uri}"
    #          fe.add(cf.uri)
    #        end
  end
  
  desc "Creates and empty Critical Edition. Options nick=<nick> name=<full_name> description=<short_description>" 
  task :create_critical_edition => 'disco_init' do
    
    ce = TaliaCore::CriticalEdition.new(N::LOCAL + ENV['nick'])
    ce.hyper::title << ENV['name']
    ce.hyper::desctiption << ENV['description']
    ce.save!    
  end
end