# Rake tasks for the discovery app
$: << File.join('vendor', 'plugins', 'talia_core', 'lib')

require File.dirname(__FILE__) + '/task_helpers'

require 'rake'
require 'talia_util'
require 'fileutils'
require 'progressbar'
require 'benchmark'
require 'csv'
require 'cgi'
require 'digest/md5'
require 'iconv'

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
  
  desc "Rebuild the RDF store from the database"
  task :rebuild_rdf => :disco_init do
    Util::flush_rdf
    puts "Flushed RDF"
    count = TaliaCore::ActiveSource.count
    puts "Rebuilding #{count} elements"
    prog = ProgressBar.new('Rebuilding', count)
    TaliaCore::ActiveSource.find(:all).each do |source|
      source.save!
      prog.inc
    end
    prog.finish
  end
  
  desc "Clear all the data (files and data store) if this instance."
  task :clear_all => 'talia_core:clear_store' do
    data_dir = TaliaCore::CONFIG['data_directory_location']
    iip_dir = TaliaCore::CONFIG['iip_root_directory_location']
    FileUtils.rm_rf(data_dir) if(File.exist?(data_dir))
    FileUtils.rm_rf(iip_dir) if(File.exist?(iip_dir))
  end
  
  desc "Export given language to csv file. Options language=<iso 639.1 lang code> [file=<filename>] [encoding=MAC] [separator=;] [linebreak={MAC|WIN}]"
  task :export_language => :disco_init do
    language = TaskHelper.language_for(ENV['language'])
    ic = TaksHelper.iconv_for(ENV['encoding'], 'UTF-8')
    sep = ENV['separator'] || ';'
    lbreak = (ENV['linebreak'] == 'WIN') ? "\n" : "\r"
    filename = ENV['file'] || "#{ENV['language']}_glob.csv"

    translations = Globalize::ViewTranslation.find(:all, :conditions => ['language_id = ? AND id > 7068', language.id])
    progress = ProgressBar.new('Exporting', translations.size)
    
    File.open(filename, 'w') do |io|
      CSV::Writer.generate(io, sep, lbreak) do |csv|
        for trans in translations
          text = ic.iconv(trans.text)
          key = ic.iconv(trans.tr_key)
          csv << [key, text]
          progress.inc
        end
      end
    end
    progress.finish
  end
  
  desc "Import the given language from the csv file. Options language=<iso 639.1 lang code> [file=<filename>] [encoding=MAC] [separator=;] [linebreak={MAC|WIN}]"
  task :import_language => :disco_init do
    language = TaskHelper.language_for(ENV['language'])
    ic = TaskHelper.iconv_for('UTF-8', ENV['encoding'])
    sep = ENV['separator'] || ';'
    lbreak = (ENV['linebreak'] == 'WIN') ? "\n" : "\r"
    filename = ENV['file'] || "#{ENV['language']}_glob.csv"

    data = File.open(filename) { |io| ic.iconv(io.read) }
    CSV::Reader.parse(data, sep, lbreak) do |row|
      trans = nil
      unless(trans = (ViewTranslation.find(:first, :conditions => {:tr_key => row[0], :language_id => language.id})))
        trans = ViewTranslation.new
        trans.tr_key = row[0]
        trans.language = language
        trans.pluralization_index = 1
      end
      trans.text = row[1]
      trans.save!
      print '.'
    end
    puts 'Done'
  end
  
  desc "Import from Sophiavision CSV file. Options csvfile=<file> [thumbnail_directory=<dir>] [encoding=MAC]"
  task :sophia_csv => :disco_init do
    ENV['nick'] = 'default'
    ENV['name'] = 'default'
    encoding = ENV['encoding'] || 'MAC'
    ic = Iconv.new('UTF-8', encoding)
    input = File.open(ENV['csvfile']) { |io| ic.iconv(io.read) }
    row_count = 0
    CSV::Reader.parse(input, ';', "\r") do |row|
      row_count += 1
      if(row.size > 9)
        TaskHelper::media_from_row(row, ENV['thumbnail_directory'])
        print '.'
      else
        print '_'
      end
    end
    puts
    puts 'done'
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
  
  desc "Import data from a local XML file. Options: xml=<file_path> [prepared_image=<directory>]"
  task :import_from_file => :disco_init do
    xml_file = ENV['xml']
    assit(File.exist?(xml_file))
    TaliaUtil::XmlImport::options[:prepared_images] = ENV['prepared_images'] if(ENV['prepared_images'])
    TaliaUtil::XmlImport::import(xml_file)
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
  desc "Creates a Facsimile Edition with all the available color facsimiles. Options nick=<nick> name=<full_name> description=<short_description> header=<header_image_folder> catalog=<catalog_siglum>"
  task :create_color_facsimile_edition => :disco_init do
    if ENV['catalog'].nil? 
      catalog = TaliaCore::Catalog.default_catalog
    else
      assit(TaliaCore::Catalog.exists?(N::LOCAL + ENV['catalog'])) 
      catalog = TaliaCore::Catalog.find(N::LOCAL + ENV['catalog']) 
    end
    facsimiles = 0
    elapsed = Benchmark.realtime do
      TaliaCore::Book
      TaliaCore::Page
      TaliaCore::Facsimile
      fe = TaskHelper::create_edition(TaliaCore::FacsimileEdition)
      TaskHelper::setup_header_images
      fe.hyper::description << ENV['description']
      qry = TaskHelper::default_book_query(catalog)
      qry.where(:facsimile, N::HYPER.manifestation_of, :page)
      qry.where(:facsimile, N::RDF.type, N::HYPER + 'Facsimile')
      qry.where(:facsimile, N::RDF.type, N::HYPER + 'Color')
      
      facs_size = TaskHelper::count_color_facsimiles_in(catalog)
      
      # Process all the books
      TaskHelper::process_books(qry.execute, facs_size) do |book, progress|
        # Add a clone to the FE, and execute the block for each page.
        book.clone_to(fe) do |orig_page, new_page|
          assit_kind_of(TaliaCore::Page, new_page)
          # Select the manifestations
          qry_man = TaskHelper::manifestations_query_for(orig_page)
          qry_man.where(:manifestation, N::RDF.type, N::HYPER + 'Facsimile')
          qry_man.where(:manifestation, N::RDF.type, N::HYPER + 'Color')
      
          qry_man.execute.each do |facsimile|
            # We just have to add the manifestation element - this is done
            # "manually" to avoid uneccessary calls to re-create the RDF
            TaskHelper::quick_add_property(facsimile, N::HYPER.manifestation_of, new_page)
            facsimiles += 1
            progress.inc
          end
        end
      end
    end
    puts "Edition created with #{facsimiles} facsimiles. Creation time: %.2f" % elapsed
  end
  
  desc "Append the given data to a critical edition (ignores existing elements)"
  task :add_to_critical_edition => :disco_init do
    # FIXME: QUICK HACK
    TaliaCore::Book
    TaliaCore::Page
    TaliaCore::Chapter
    TaliaCore::Paragraph
    TaliaCore::TextReconstruction
    TaliaCore::Transcription
    TaliaCore::HyperEdition
    
    ed_uri = N::LOCAL +  TaliaCore::CriticalEdition::EDITION_PREFIX + '/' + ENV['nick']
    raise(RuntimeError, "Edition does not exist: #{ed_uri}") unless(TaliaCore::ActiveSource.exists?(ed_uri))
    ce = TaliaCore::ActiveSource.find(ed_uri)
    
    if ENV['catalog'].nil? 
      catalog = TaliaCore::Catalog.default_catalog
    else
      assit(TaliaCore::Catalog.exists?(N::LOCAL + ENV['catalog'])) 
      catalog = TaliaCore::Catalog.find(N::LOCAL + ENV['catalog']) 
    end
    
    # HyperEditions may be manifestations of both pages and paragraphs
    par_qry = TaskHelper::default_book_query(catalog)
    par_qry.where(:paragraph, N::HYPER.note, :note)
    par_qry.where(:note, N::HYPER.page, :page)
    par_qry.where(:edition, N::HYPER.manifestation_of, :paragraph)
    par_qry.where(:edition, N::RDF.type, N::HYPER + 'HyperEdition')
    
    pag_qry = TaskHelper::default_book_query(catalog)
    pag_qry.where(:edition, N::HYPER.manifestation_of, :page)
    pag_qry.where(:edition, N::RDF.type, N::HYPER + 'HyperEdition')
    
    pag_books = pag_qry.execute
    par_books = par_qry.execute
    books = par_books + (pag_books - par_books)

    note_count = TaskHelper::count_notes_in(catalog)
    notes = 0
    
    TaskHelper::process_books(books, note_count) do |book, progress|
      new_book = begin
        book.clone_to(ce) do |orig_page, new_page|
          assit_kind_of(TaliaCore::Page, new_page)
        
          # Clone all editions that may exist on the page itself
          # TODO: Why are editions existing on the page itself?
          TaskHelper::clone_hyper_editions(orig_page, new_page)
        
          # Go through all the notes of the current page
          orig_page.notes.each do |note|
            new_note = ce.add_from_concordant(note)
            new_note.hyper::page << new_page
            TaskHelper::handle_paragraph_for(note, new_note, ce)
            progress.inc
            new_note.save!
            notes += 1
          end
        end
      rescue Exception => e
        puts "Could not clone #{book.uri}: #{e.message}"
      end
      
      # Now clone the chapters on the book      
      book.chapters.each do |chapter|
        begin
          ce.add_from_concordant(chapter) do |cloned_chapt|
            cloned_chapt.book = new_book
            chapt_first = chapter.first_page
            if(chapt_first)
              first_page = chapt_first.concordant_cards(ce).first
              assit(first_page, "Must have a first page on the chapter #{chapter.uri}.")
              cloned_chapt.first_page = first_page
              cloned_chapt.save!
            else
              assit_fail("First page doesn't exist on #{chapter.uri}")
            end
          end
        rescue Exception => e
          puts "Could not clone chapter #{chapter.uri}: #{e.message}"
        end
      end      
      if(new_book)
        new_book.chapters.each do |chapter|
          chapter.order_pages!
        end
        begin
          new_book.create_html_data!
        rescue Exception => e
          puts "Error creating html for #{new_book.uri}: #{e.message}"
        end
      end
    end
  end
  
  
  desc "Creates a Critical Edition with all the HyperEditions related to any subparts of any book in the default catalog. Options nick=<nick> name=<full_name> header=<header_directory> descr  iption=<html_description_file> catalog=<catalog_siglum>"
  task :create_critical_edition => :disco_init do
 
    TaliaCore::Book
    TaliaCore::Page
    TaliaCore::Chapter
    TaliaCore::Paragraph
    TaliaCore::TextReconstruction
    TaliaCore::Transcription
    TaliaCore::HyperEdition
    
    if ENV['catalog'].nil? 
      catalog = TaliaCore::Catalog.default_catalog
    else
      assit(TaliaCore::Catalog.exists?(N::LOCAL + ENV['catalog'])) 
      catalog = TaliaCore::Catalog.find(N::LOCAL + ENV['catalog']) 
    end
    
    ce = TaskHelper::create_edition(TaliaCore::CriticalEdition)
    TaskHelper::setup_header_images
    # the description page must be passed as a path to the HTML file containing it
    description_file_path = ENV['description']
    ce.create_html_description!(description_file_path)
    
    # HyperEditions may be manifestations of both pages and paragraphs
    par_qry = TaskHelper::default_book_query(catalog)
    par_qry.where(:paragraph, N::HYPER.note, :note)
    par_qry.where(:note, N::HYPER.page, :page)
    par_qry.where(:edition, N::HYPER.manifestation_of, :paragraph)
    par_qry.where(:edition, N::RDF.type, N::HYPER + 'HyperEdition')
    
    pag_qry = TaskHelper::default_book_query(catalog)
    pag_qry.where(:edition, N::HYPER.manifestation_of, :page)
    pag_qry.where(:edition, N::RDF.type, N::HYPER + 'HyperEdition')
    
    pag_books = pag_qry.execute
    par_books = par_qry.execute
    books = par_books + (pag_books - par_books)

    note_count = TaskHelper::count_notes_in(catalog)
    page_count = TaskHelper::count_pages_in(catalog)
 
    subparts_count = page_count + note_count 
    
    TaskHelper::process_books(books, subparts_count) do |book, progress|
      new_book = book.clone_to(ce) do |orig_page, new_page|
        begin
          assit_kind_of(TaliaCore::Page, new_page)
        
          # Clone all editions that may exist on the page itself
          # TODO: Why are editions existing on the page itself?
          TaskHelper::clone_hyper_editions(orig_page, new_page)
          progress.inc

          # Go through all the notes of the current page
          orig_page.notes.each do |note|
            new_note = ce.add_from_concordant(note)
            new_note.hyper::page << new_page
            TaskHelper::handle_paragraph_for(note, new_note, ce)
            progress.inc
            new_note.save!
          end
        rescue Exception => e
          puts "Exception cloning page #{orig_page.uri}: #{e.message}"
        end
      end
      
      # Now clone the chapters on the book      
      book.chapters.each do |chapter|
        begin
          ce.add_from_concordant(chapter) do |cloned_chapt|
            cloned_chapt.book = new_book
            chapt_first = chapter.first_page
            if(chapt_first)
              first_page = chapt_first.concordant_cards(ce).first
              assit(first_page, "Must have a first page on the chapter #{chapter.uri}.")
              cloned_chapt.first_page = first_page
              cloned_chapt.save!
            else
              assit_fail("First page doesn't exist on #{chapter.uri}")
            end
          end
        rescue Exception => e
          puts "Error cloning chapter #{chapter}: #{e.message}"
        end
      end          
      new_book.chapters.each do |chapter|
        chapter.order_pages!
      end
      begin
        new_book.create_html_data!
      rescue Exception => e
        puts "Error creating html for #{new_book.uri}: #{e.message}"
      end
    end
  end
  
  desc "recreate the book_html of all book in one catalog. Options catalog=<catalog>"
  task :recreate_books_html => :disco_init do
    TaliaCore::Book
    TaliaCore::Page
    TaliaCore::Chapter
    TaliaCore::Paragraph
    TaliaCore::TextReconstruction
    TaliaCore::Transcription
    TaliaCore::HyperEdition
    
    assit(TaliaCore::Catalog.exists?(N::LOCAL + ENV['catalog'])) 
    catalog = TaliaCore::Catalog.find(N::LOCAL + ENV['catalog']) 

    qry = Query.new(TaliaCore::Book).select(:book).distinct
    qry.where(:book, N::HYPER.in_catalog, catalog)
    qry.where(:book, N::RDF.type, N::HYPER.Book)
    books = qry.execute

    progress = ProgressBar.new('Books', books.size)
    
    books.each do |book|
      book.recreate_html_data!
      progress.inc
    end
    progress.finish
    
  end
  
  
  
  
  desc "Upload data into eXist database. Option: [contribution_uri=<contribution_uri>] (if not given, upload all contributions)" 
  task :feeder_upload => :disco_init do
    
    feeder = Feeder.new
    
    if ENV['contribution_uri'].nil? || ENV['contribution_uri'] == ""
    
      contributions = TaskHelper::contributions
    
      progress_size ||= contributions.size
      puts "Processing #{progress_size} contributions (#{progress_size} elements to process)..."
      progress = ProgressBar.new('Contributions', progress_size)
      contributions.each do |contribution|
        begin
          feeder.feed_contribution(contribution.uri)
        rescue Exception => e
          puts "Error feeding contribution #{contribution.uri}: #{e.message}"
        end
        progress.inc
      end
      progress.finish
    else
      progress_size = 1
      puts "Processing #{progress_size} contributions (#{progress_size} elements to process)..."
      progress = ProgressBar.new('Contributions', progress_size)
      feeder.feed_contribution(ENV['contribution_uri'])
      progress.finish
    end
    
  end
  
  namespace :pdf do
    desc "Prepare the environment for PDF tasks"
    task :prepare => [ 'disco_init', 'talia_core:talia_init' ] do
      DATA_PATH = File.join(TALIA_ROOT, "data") unless defined? DATA_PATH
    end

    namespace :create do
      desc "Create both PDF books and pages"
      task :all => [ :books, :pages ]

      desc "Create PDF books"
      task :books => :prepare do
        require 'pdf/writer'
        logger = TaliaCore::Book.logger

        pdf_path = File.join(DATA_PATH, 'PdfData')
        FileUtils.mkdir_p pdf_path

        TaliaCore::Book.find(:all).each do |book|
          title = book.uri.local_name
          logger.info "[#{Time.now.to_s(:long)}] Generating #{title.titleize}"

          elapsed = Benchmark.realtime do
            PDF::Writer.new do |pdf|
              filename = "#{title}.pdf"
              book.ordered_pages.each do |page|
                # In order to make the image fit inside the page I have to resize it with this
                # "magic number" (0.85), because the original pages doesn't have the same proportion
                # of the A4 format.
                # This means to have (for now) ugly and wide white borders.
                # TODO find the right way to pack the images
                pdf.image page.image_path, :justification => :center, :resize => 0.85
              end
            end.save_as File.join(pdf_path, filename)

            TaliaCore::DataTypes::PdfData.create :location => filename, :source_id => book.id
          end

          logger.info("[#{Time.now.to_s(:long)}] #{title.titleize} generated in %.2f secs" % elapsed)
        end
      end
      
      desc "Create PDF pages"
      task :pages => :prepare do
        require 'pdf/writer'
        logger = TaliaCore::Page.logger

        pdf_path = File.join(DATA_PATH, 'PdfData')
        FileUtils.mkdir_p pdf_path

        pages = TaliaCore::Page.find(:all)
        puts "Processing #{pages.size} pages"
        progress = ProgressBar.new("PDF creation", pages.size)
        found = 0
        not_found = 0
        
        pages.each do |page|
          title = page.uri.local_name
          logger.info "[#{Time.now.to_s(:long)}] Generating #{title.titleize}"

          progress.inc
          
          filename = page.uri.local_name + '.pdf'
          
          f_path = page.image_path
          elapsed = 0
          if(f_path)
            found += 1
            elapsed = Benchmark.realtime do
              PDF::Writer.new do |pdf|
                filename = "#{title}.pdf"
                # In order to make the image fit inside the page I have to resize it with this
                # "magic number" (0.85), because the original pages doesn't have the same proportion
                # of the A4 format.
                # This means to have (for now) ugly and wide white borders.
                # TODO find the right way to pack the images
                pdf.image f_path, :justification => :center, :resize => 0.85
              end.save_as File.join(pdf_path, filename)
            end
          else
            not_found += 1
          end

          TaliaCore::DataTypes::PdfData.create :location => filename, :source_id => page.id
       
          logger.info("[#{Time.now.to_s(:long)}] #{title.titleize} generated in %.2f secs" % elapsed)
          
        end
        progress.finish
        puts "Done. Found #{found} pages with images and #{not_found} without"
      end
    end

    desc "Clear both generated PDF books and pages"
    task :clear => :prepare do
      pdf_path = File.join(DATA_PATH, 'PdfData', "*", "*.pdf")
      logger = TaliaCore::Book.logger
      logger.info "[#{Time.now.to_s(:long)}] deleting all generated PDF"

      elapsed = Benchmark.realtime do
        locations = Dir[pdf_path].map do |file|
          FileUtils.rm file
          file.split(File::SEPARATOR).last
        end
        TaliaCore::Book.delete_all([ "location IN(?)", locations ]) if locations.any?
      end
      
      logger.info("[#{Time.now.to_s(:long)}] deleted all genetated PDF in %.2f secs" % elapsed)
    end
    
    
    desc "Additional help on Discovery/Talia tasks"
    task :help do
      puts "The hyper_download and prepare_images scripts can be used to prepare"
      puts "a local copy of the data. This will allow for a faster 'offline' import."
      puts 
      puts "The importing tasks can alse take the [delay_file_copies=yes] and [fast_copies=yes] options."
      puts "See the documentation of the FileStore class for more information."
    end
    
  end
end
