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
    #FIXME: should we include some classes for making this work?
    #    validate_format_of ENV['nick'], :with => /[^ ]/, :message => "Nickames can't contain spaces"
    fe = TaliaCore::FacsimileEdition.new(N::LOCAL +  TaliaCore::FACSIMILE_EDITION_PREFIX + '/' + ENV['nick'])
    fe.hyper::title << ENV['name']
    fe.hyper::description << ENV['description']
    fe.save!
  end
  
  # creates a facsimile edition and adds to it all the color facsimiles found in the DB
  desc "Creates a Facsimile Edition with all the available color facsimiles. Options nick=<nick> name=<full_name> description=<short_description>"
  task :create_color_facsimile_edition => 'create_facsimile_edition' do
 
    # loads the TaliaCore::Page class, so the "add_from_concordant method of the Catalog class
    # an find them. Here we'll need just pages (this is the Nietzsche case)
    TaliaCore::Page   

    fe = TaliaCore::FacsimileEdition.find(N::LOCAL + TaliaCore::FACSIMILE_EDITION_PREFIX + '/' + ENV['nick'])
    qry = Query.new(TaliaCore::Book).select(:b).distinct
    qry.where(:b, N::RDF.type, N::HYPER.Book)
    qry.where(:p, N::HYPER.part_of, :b)
    #    qry.where(:f, N::HYPER.manifestation_of, :p)
    #TODO: for testing I'm using N::HYPER.cites 
    # remove it and uncomment the above line when it works 
    qry.where(:f, N::HYPER.cites, :p)
    qry.where(:f, N::RDF.type, N::HYPER.Facsimile)
    qry.where(:f, N::RDF.type, N::HYPER.Color)
    qry.execute.each do |book| 
      fe.add_from_concordant(book, true) 
      book.pages.each do |page|
        fe_page = TaliaCore::Page.find(fe.uri + '/' + page.siglum)
        qry = Query.new(TaliaCore::Facsimile).select(:f).distinct.limit(1)
        #    qry.where(:f, N::HYPER.manifestation_of, page)
        #TODO: for testing I'm using N::HYPER.cites 
        # remove it and uncomment the above line when it works 
        qry.where(:f, N::HYPER.cites, page)       
        qry.where(:f, N::RDF.type, N::HYPER.Facsimile)
        qry.where(:f, N::RDF.type, N::HYPER.Color)    
        fe_page.add_manifestation(qry.execute[0])
      end
    end
    fe.books.each do |book|
      book.order_pages!
    end
  end

  
  desc "Creates and empty Critical Edition. Options nick=<nick> name=<full_name> description=<short_description>" 
  task :create_critical_edition => 'disco_init' do
    
    ce = TaliaCore::CriticalEdition.new(N::LOCAL + ENV['nick'])
    ce.hyper::title << ENV['name']
    ce.hyper::desctiption << ENV['description']
    ce.save!    
  end
end