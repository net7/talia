# Rake tasks for the discovery app
$: << File.join('vendor', 'plugins', 'talia_core', 'lib')

require File.dirname(__FILE__) + '/task_helpers'

require 'rake'
require 'talia_util'
require 'fileutils'
require 'progressbar'
require 'benchmark'

include TaliaUtil

namespace :discovery do
  
  desc "Init for this tasks"
  task :disco_init do # => 'talia_core:talia_init' do
    unless(@talia_is_init)
      # Dependencies.load_paths << File.join(File.dirname(__FILE__), '..', '..', 'app', 'models')
      require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
      TaskHelper::load_consts
      @talia_is_init = true
    end
  end
  
  desc "Prepares the environment for the test server"
  task :prep_testserver => :disco_init do
    ENV['base_url'] = ''
    ENV['list_path'] = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'vendor', 'plugins', 'talia_core', 'lib', 'talia_util', 'some_sigla.xml'))
    ENV['doc_path'] = 'http://www.nietzschesource.org/exportToTalia.php?get='
    ENV['nick'] = 'nietzsche'
    ENV['name'] = 'Nietzsche Edition for automated tests'
    ENV['description'] = 'Edition of two nietzsche books. Made for automated tests.'
    Util.flush_db
    Util.flush_rdf
  end
  
  
  desc "Import data and prepare the test server. Downloads data directly from the net."
  task :setup_testserver => [:prep_testserver, :hyper_import, :create_color_facsimile_edition]
  
  # Import from Hyper
  desc "Import data from Hyper. Options: base_url=<base_url> [list_path=?get_list=all] [doc_path=?get=] [extension=] [user=<username> password=<pass>] [prepared_images=<directory>]"
  task :hyper_import => :disco_init do
    # The list file will be relative to the current dir, not the doc dir
    list_path = ENV['list_path']
    if((!ENV['base_url'] || ENV['base_url'] == '') && File.exist?(list_path))
      list_path = File.expand_path(list_path)
    end
    if(File.directory?(doc_dir = File.join(ENV['base_url'], ENV['doc_path'])))
      puts "Setting directory to #{doc_dir}"
      FileUtils.cd(doc_dir)
    end
    TaliaUtil::HyperXmlImport::options[:prepared_images] = ENV['prepared_images'] if(ENV['prepared_images'])
    TaliaUtil::HyperXmlImport::set_auth(ENV['user'], ENV['password'])
    TaliaUtil::HyperXmlImport::import(ENV['base_url'], list_path, ENV['doc_path'], ENV['extension'])
  end
  
  # creates a facsimile edition and adds to it all the color facsimiles found in the DB
  desc "Creates a Facsimile Edition with all the available color facsimiles. Options nick=<nick> name=<full_name> description=<short_description>"
  task :create_color_facsimile_edition => :disco_init do
    facsimiles = 0
    elapsed = Benchmark.realtime do
      TaliaCore::Book
      TaliaCore::Page
      TaliaCore::Facsimile
      fe = TaskHelper::create_edition(TaliaCore::FacsimileEdition)
      
      qry = TaskHelper::default_book_query
      qry.where(:facsimile, N::HYPER.manifestation_of, :page)
      qry.where(:facsimile, N::RDF.type, N::HYPER + 'Facsimile')
      qry.where(:facsimile, N::RDF.type, N::HYPER + 'Color')
      
      facs_q = Query.new(N::URI).select(:facsimile).distinct
      facs_q.where(:facsimile, N::RDF.type, N::HYPER.Facsimile)
      facs_q.where(:facsimile, N::RDF.type, N::HYPER.Color)
      facs_q.where(:facsimile, N::HYPER.manifestation_of, :page)
      facs_q.where(:page, N::HYPER.part_of, :book)
      facs_q.where(:book, N::HYPER.in_catalog, TaliaCore::Catalog.default_catalog)
      
      facs_size = facs_q.execute.size
      
      # Process all the books
      TaskHelper::process_books(qry.execute, facs_size) do |book, progress|
        # Add a clone to the FE, and execute the block for each page.
        book.clone_to(fe) do |page|
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
            # We just have to add the manifestation element - this is done
            # "manually" to avoid uneccessary calls to re-create the RDF
            facsimile.autosave_rdf = false
            facsimile.hyper::manifestation_of << page
            facsimile.save!
            facsimile.my_rdf[N::HYPER.manifestation_of] << page
            facsimile.my_rdf.save
            facsimiles += 1
            progress.inc
          end
        end
      end
    end
    puts "Edition created with #{facsimiles} facsimiles. Creation time: %.2f" % elapsed
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

    # HyperEditions may be manifestations of both pages and paragraphs
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
    # Paragraphs are not added by the add_from_concordant catalog's method called 
    # in the TaskHelper::add_books_to_edition one as they are not in a relation
    # of the kind N::HYPER.part_of with the books. 
    # Paragraphs are related to notes which, in turns, are related to pages.
    # Notes are not cloned and, as such, they are related to pages _in the default catalog_.
    query = Query.new(TaliaCore::Source).select(:paragraph).distinct
    query.where(:book, N::RDF.type, N::HYPER.Book)
    # only select from the default catalog
    query.where(:book, N::HYPER.in_catalog, TaliaCore::Catalog.default_catalog)
    query.where(:page, N::HYPER.part_of, :book)
    query.where(:paragraph, N::RDF.type, N::TALIA.Paragraph)
    query.where(:paragraph, N::HYPER.note, :note)
    query.where(:note, N::HYPER.page, :page)
    query.where(:edition, N::HYPER.manifestation_of, :paragraph)
    query.where(:edition, N::RDF.type, N::HYPER + 'HyperEdition')
    paragraphs = query.execute
    puts "Found #{paragraphs.size} paragraphs in the new edition. Adding HyperEdition."
    progress = ProgressBar.new('Editions', paragraphs.size)
    editions = 0
    # Let's add the paragraphs to the critical edition...
    paragraphs.each do |paragraph|
      new_paragraph = ce.add_from_concordant(paragraph, false) # no children imported
      assit_kind_of(TaliaCore::Paragraph, new_paragraph)
      # Select the manifestations of the paragraphs, we are interested in just
      # Editions and Transcriptions (that is N::HYPER.HyperEdition)
      qry_edi = Query.new(TaliaCore::Source).select(:edition).distinct
      qry_edi.where(:concordance, N::HYPER.concordant_to, new_paragraph)
      qry_edi.where(:concordance, N::HYPER.concordant_to, :def_paragraph)
      qry_edi.where(:def_paragraph, N::HYPER.in_catalog, TaliaCore::Catalog.default_catalog)
      qry_edi.where(:edition, N::HYPER.manifestation_of, :def_paragraph)
      qry_edi.where(:edition, N::RDF.type, N::HYPER + 'HyperEdition')
      # Manifestations of the old, cloned, paragraphs are added to the new clones
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
    puts "Found #{pages.size} pages in the new edition. Adding HyperEditions."
    progress = ProgressBar.new('Page Editions', pages.size)
    page_editions = 0
    pages.each do |page|
      assit_kind_of(TaliaCore::Page, page)
      # Select the manifestations of the pages to be added, again only HyperEditions 
      # are interesting here
      qry_edi = Query.new(TaliaCore::Source).select(:edition).distinct
      qry_edi.where(:concordance, N::HYPER.concordant_to, page)
      qry_edi.where(:concordance, N::HYPER.concordant_to, :def_page)
      qry_edi.where(:def_page, N::HYPER.in_catalog, TaliaCore::Catalog.default_catalog)
      qry_edi.where(:edition, N::HYPER.manifestation_of, :def_page)
      qry_edi.where(:edition, N::RDF.type, N::HYPER + 'HyperEdition')
      # Let's add manifestation to the new pages
      qry_edi.execute.each do |edition|
        page.add_manifestation(edition)
        edition.save!
        page_editions += 1
      end
      page.save!
      progress.inc
    end
    progress.finish
 
    # Now it's chapters' turn. 
    puts "Importing Chapters..."
    ce.books.each do |book|    
      # it creates ordered_source for the pages (it's needed anyway, but also the chapters
      # need them)
      book.order_pages!   
      # it searches for chapters and adds them to the Critical Edition
      qry_chapt = Query.new(TaliaCore::Source).select(:chapter).distinct
      qry_chapt.where(:concordance, N::HYPER.concordant_to, book)
      qry_chapt.where(:concordance, N::HYPER.concordant_to, :def_book)
      qry_chapt.where(:def_book, N::HYPER.in_catalog, TaliaCore::Catalog.default_catalog)
      qry_chapt.where(:chapter, N::HYPER.book, :def_book)
      qry_chapt.where(:chapter, N::RDF.type, N::TALIA.Chapter)

      chapters = qry_chapt.execute
      chapters.each do |chapter| 
        ce.add_from_concordant(chapter, false) # don't import subelements
      end unless chapters.empty?
      book_chapters = book.chapters
      book_chapters.each do |chapter| 
        chapter.order_pages!
        if chapter.ordered_pages.size == 0
          #TODO: it may happen that a chapter is added even if there are no HyperEdition
          # in it, either we delete it now or we don't add it in the first place (how?)
        end
      end unless book_chapters.empty?
      puts "Creating html_data of #{book}"
      book.create_html_data!
    end
    puts "Edition created with #{editions} editions."
  end
  
  namespace :pdf do
    desc "Create pdf books"
    task :create => [ 'disco_init', 'talia_core:talia_init' ] do
      require 'pdf/writer'
      
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
