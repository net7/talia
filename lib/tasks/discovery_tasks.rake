# Rake tasks for the discovery app
$: << File.join('vendor', 'plugins', 'talia_core', 'lib')

require File.dirname(__FILE__) + '/task_helpers'

require 'rake'
require 'talia_util'
require 'fileutils'
require 'progressbar'

include TaliaUtil

namespace :discovery do
  
  desc "Init for this tasks"
  task :disco_init do # => 'talia_core:talia_init' do
    # Dependencies.load_paths << File.join(File.dirname(__FILE__), '..', '..', 'app', 'models')
    require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
    TaskHelper::load_consts
  end
  
  # Import from Hyper
  desc "Import data from Hyper. Options: base_url=<base_url> [list_path=?get_list=all] [doc_path=?get=] [extension=] [user=<username> password=<pass>]"
  task :hyper_import => :disco_init do
    # The list file will be relative to the current dir, not the doc dir
    list_path = ENV['list_path']
    if((!ENV['base_url'] || ENV['base_url'] == '') && File.exist?(list_uri))
      list_path = File.expand_path(list_uri)
    end
    if(File)
    if(File.directory?(doc_dir = File.join(ENV['base_url'], ENV['doc_path'])))
      puts "Setting directory to #{doc_dir}"
      FileUtils.cd(doc_dir)
    end
    TaliaUtil::HyperXmlImport::set_auth(ENV['user'], ENV['password'])
    TaliaUtil::HyperXmlImport::import(ENV['base_url'], list_path, ENV['doc_path'], ENV['extension'])
  end
  
  # creates a facsimile edition and adds to it all the color facsimiles found in the DB
  desc "Creates a Facsimile Edition with all the available color facsimiles. Options nick=<nick> name=<full_name> description=<short_description>"
  task :create_color_facsimile_edition => :disco_init do 
    TaliaCore::Book
    TaliaCore::Page
    TaliaCore::Facsimile
    fe = TaskHelper::create_edition(TaliaCore::FacsimileEdition)
    qry = TaskHelper::default_book_query
    qry.where(:facsimile, N::HYPER.manifestation_of, :page)
    qry.where(:facsimile, N::RDF.type, N::HYPER + 'Facsimile')
    qry.where(:facsimile, N::RDF.type, N::HYPER + 'Color')
    # Add the books to the edition
    TaskHelper::add_books_to_edition(fe, qry.execute)
    # Go through the pages and add the manifestations
    pages = fe.elements_by_type(N::TALIA.Page)
    puts "Found #{pages.size} pages in the new edition. Adding Facsimiles."
    progress = ProgressBar.new('Facsimiles', pages.size)
    facsimiles = 0
    pages.each do |page|
      assit_kind_of(TaliaCore::Page, page)
      # Select the manifestations
      qry_man = Query.new(TaliaCore::Source).select(:facsimile).distinct
      qry_man.where(:concordance, N::HYPER.concordant_to, page)
      qry_man.where(:concordance, N::HYPER.concordant_to, :def_page)
      qry_man.where(:def_page, N::HYPER.in_catalog, TaliaCore::Catalog.default_catalog)
      qry_man.where(:facsimile, N::HYPER.manifestation_of, :def_page)
      qry_man.where(:facsimile, N::RDF.type, N::HYPER + 'Facsimile')
      qry_man.where(:facsimile, N::RDF.type, N::HYPER + 'Color')
      
      qry_man.execute.each do |facsimile|
        page.add_manifestation(facsimile)
        facsimile.save!
        facsimiles += 1
        
      end
      page.save!
      
      progress.inc
    end
    progress.finish
    puts "Ordering Book pages..."
    fe.books.each do |book|
      book.order_pages!
    end
    puts "Edition created with #{facsimiles} facsimiles."
  end

  
  desc "Creates a Critical Edition with all the HyperEditions related to any subparts of any book in the default catalog. Options nick=<nick> name=<full_name> description=<short_description>" 
  task :create_critical_edition => :disco_init do

    TaliaCore::Book
    TaliaCore::Page
    TaliaCore::Chapter
    TaliaCore::Paragraph
    TaliaCore::Edition
    TaliaCore::Transcription
    TaliaCore::HyperEdition
    ce = TaskHelper::create_edition(TaliaCore::CriticalEdition)

    par_qry = TaskHelper::default_book_query
    par_qry.where(:paragraph, N::HYPER.note, :note)
    par_qry.where(:note, N::HYPER.page, :page)
    par_qry.where(:edition, N::HYPER.manifestation_of, :paragraph)
    par_qry.where(:edition, N::RDF.type, N::HYPER + 'HyperEdition')
    
    pag_qry = TaskHelper::default_book_query
    pag_qry.where(:edition, N::HYPER.manifestation_of, :page)
    pag_qry.where(:edition, N::RDF.type, N::HYPER + 'HyperEdition')
    
    pag_books = pag_qry.execute
    par_books = par_qry.execute
    books = par_books + (pag_books - par_books)
    
    # Add the books to the edition (it will add pages too)
    TaskHelper::add_books_to_edition(ce, books)
    # Go through the paragraphs and add the manifestations
    query = Query.new(TaliaCore::Source).select(:paragraph).distinct
    query.where(:book, N::RDF.type, N::HYPER.Book)
    # only select from the default catalog
    query.where(:book, N::HYPER.in_catalog, TaliaCore::Catalog.default_catalog)
    query.where(:page, N::HYPER.part_of, :book)
    query.where(:paragraph, N::HYPER.note, :note)
    query.where(:note, N::HYPER.page, :page)
    query.where(:edition, N::HYPER.manifestation_of, :paragraph)
    query.where(:edition, N::RDF.type, N::HYPER + 'HyperEdition')
    
    paragraphs = query.execute
    puts "Found #{paragraphs.size} paragraphs in the new edition. Adding HyperEdition."
    progress = ProgressBar.new('Editions', paragraphs.size)
    editions = 0
    paragraphs.each do |paragraph|
      new_paragraph = ce.add_from_concordant(paragraph, false) # no children imported
      assit_kind_of(TaliaCore::Paragraph, new_paragraph)
      # Select the manifestations
      qry_edi = Query.new(TaliaCore::Source).select(:edition).distinct
      qry_edi.where(:concordance, N::HYPER.concordant_to, new_paragraph)
      qry_edi.where(:concordance, N::HYPER.concordant_to, :def_paragraph)
      qry_edi.where(:def_paragraph, N::HYPER.in_catalog, TaliaCore::Catalog.default_catalog)
      qry_edi.where(:edition, N::HYPER.manifestation_of, :def_paragraph)
      qry_edi.where(:edition, N::RDF.type, N::HYPER + 'HyperEdition')
      
      qry_edi.execute.each do |edition|
        new_paragraph.add_manifestation(edition)
        edition.save!
        editions += 1
      end
      new_paragraph.save!
      
      progress.inc
    end
    progress.finish
 
    pages = ce.elements_by_type(N::TALIA.Page)
    puts "Found #{pages.size} pages in the new edition. Adding HyperEdition."
    progress = ProgressBar.new('Page Editions', pages.size)
    page_editions = 0
    pages.each do |page|
      assit_kind_of(TaliaCore::Page, page)
      # Select the manifestations
      qry_edi = Query.new(TaliaCore::Source).select(:edition).distinct
      qry_edi.where(:concordance, N::HYPER.concordant_to, page)
      qry_edi.where(:concordance, N::HYPER.concordant_to, :def_page)
      qry_edi.where(:def_page, N::HYPER.in_catalog, TaliaCore::Catalog.default_catalog)
      qry_edi.where(:edition, N::HYPER.manifestation_of, :def_page)
      qry_edi.where(:edition, N::RDF.type, N::HYPER + 'HyperEdition')
      
      qry_edi.execute.each do |edition|
        page.add_manifestation(edition)
        edition.save!
        page_editions += 1
      end
      page.save!
      progress.inc
    end
    progress.finish
 
    puts "Importing Chapters..."
    ce.books.each do |book|    
      book.order_pages!   
      qry_chapt = Query.new(TaliaCore::Source).select(:chapter).distinct
      qry_chapt.where(:concordance, N::HYPER.concordant_to, book)
      qry_chapt.where(:concordance, N::HYPER.concordant_to, :def_book)
      qry_chapt.where(:def_book, N::HYPER.in_catalog, TaliaCore::Catalog.default_catalog)
      qry_chapt.where(:chapter, N::HYPER.book, :def_book)
      qry_chapt.where(:edition, N::RDF.type, N::TALIA.Chapter)

      qry_chapt.execute.each do |chapter|
        ce.add_from_concordant(chapter, false) #don't import subelements
      end
      book.chapters.each do |chapter|
        chapter.order_pages!
        if chapter.ordered_pages.size == 0
          #TODO: it may happen that a chapter is added even if there are no HyperEdition
          # in it, either we delete it now or we don't add it in the first place
        end
      end
    end
    puts "Edition created with #{editions} editions."
  end
  
  namespace :pdf do
    desc "Create pdf books"
    task :create => [ 'disco_init', 'talia_core:talia_init' ] do
      require 'pdf/writer'
      require 'benchmark'
      
      # TODO Choose a directory where to place the generated books.
      #
      # TODO Should each generated book be a source?
      # In this case, should pdf be placed under 'data/PdfData'?
      FileUtils.mkdir_p 'pdf'
      TaliaCore::Book.find(:all).each do |book|
        # TODO is the right way to address a book? Is there a 'title' attribute?
        title = book.uri.local_name
        print title.titleize

        elapsed = Benchmark.realtime do
          PDF::Writer.new do |pdf|
            book.ordered_pages.each do |page|
              # TODO We have to implement a Page#image method, to retrive the image representation
              # of the page
              #
              # TODO Should we consider to decrease the image quality? Each page is about 5Mb,
              # this means to generate documents of houndreds of Mb, that's are hard to create,
              # move, and distribute.
              # If we choose to maintain the actual quality, I advise to serve those files with
              # a static webserver (apache httpd, nginx, lighthttpd).
              #
              # TODO In order to make the image fit inside the page I have to resize it with this
              # "magic number" (0.85), because the original pages doesn't have the same proportion
              # of the A4 format.
              # This means to have (for now) ugly and wide white borders.
              pdf.image page.image, :justification => :center, :resize => 0.85
            end
          end.save_as "pdf/#{title}.pdf"
        end

        puts " %.2f" % elapsed
      end
    end
  end
end
