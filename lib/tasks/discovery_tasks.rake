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
    ontology_folder = ENV['ontology_folder'] || File.join(RAILS_ROOT, 'ontologies')
    TaskHelper::setup_ontologies(ontology_folder)
  end

  desc "Update the Ontologies. Options ontologies=<ontology_folder>"
  task :setup_ontologies => :disco_init do
    ontology_folder = ENV['ontology_folder'] || File.join(RAILS_ROOT, 'ontologies')
    TaskHelper::setup_ontologies(ontology_folder)
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
      fe.write_predicate(N::HYPER.description, ENV['description'])
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
            facsimile.write_predicate(N::HYPER.manifestation_of, new_page)
            facsimile.save!
            facsimiles += 1
            progress.inc
          end
        end
      end
    end
    puts "Edition created with #{facsimiles} facsimiles. Creation time: %.2f" % elapsed
  end
  
  
  desc "Creates a Critical Edition with all the HyperEditions related to any subparts of any book in the default catalog. Options nick=<nick> name=<full_name> header=<header_directory> description=<html_description_file> catalog=<catalog_siglum> [version=<version>]"
  task :create_critical_edition => :disco_init do
    TaliaCore::Book
    TaliaCore::Page
    TaliaCore::Chapter
    TaliaCore::Paragraph
    TaliaCore::TextReconstruction
    TaliaCore::Transcription
    TaliaCore::HyperEdition

    version = ENV['version']


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
          TaskHelper::clone_hyper_editions(orig_page, new_page)
          progress.inc

          # Go through all the notes of the current page
          orig_page.notes.each do |note|
            new_note = ce.add_from_concordant(note)
            new_note.write_predicate(N::HYPER.page, new_page)
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
        new_book.create_html_data!(version)
      rescue Exception => e
        puts "Error creating html for #{new_book.uri}: #{e.message}"
        puts e.backtrace
      end
    end
  end
  
  desc "recreate the book_html of all book in one catalog. Options catalog=<catalog> [version=<version>]"
  task :recreate_books_html => :disco_init do
    TaliaCore::Book
    TaliaCore::Page
    TaliaCore::Chapter
    TaliaCore::Paragraph
    TaliaCore::TextReconstruction
    TaliaCore::Transcription
    TaliaCore::HyperEdition

    version = ENV['version']
    
    assit(TaliaCore::Catalog.exists?(N::LOCAL + ENV['catalog'])) 
    catalog = TaliaCore::Catalog.find(N::LOCAL + ENV['catalog']) 

    qry = Query.new(TaliaCore::Book).select(:book).distinct
    qry.where(:book, N::HYPER.in_catalog, catalog)
    qry.where(:book, N::RDF.type, N::HYPER.Book)
    books = qry.execute

    progress = ProgressBar.new('Books', books.size)
    
    books.each do |book|
      book.recreate_html_data!(version)
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

  desc "Update from svn. Includes a quick hack to handle the public/xslt/p4 dir"
  task :update_app do
    xslt_path = File.join(TaskHelper::root_path, 'xslt', 'TEI')
    p4_path = File.join(xslt_path, 'p4')
    p4_back = File.join(xslt_path, 'p4.UPDATING')
    update_p4 = (File.exist?(p4_path) && !(File.exist?(File.join(p4_path, '.svn'))))
    if(update_p4)
      puts "Backing up p4 dir"
      raise(IOError, "Backup p4 dir already exists") if(File.exists?(p4_back))
      FileUtils::mv(p4_path, p4_back)
    end
    system('svn update')
    if(update_p4)
      puts "Restoring p4 dir"
      FileUtils.rm_rf(p4_path)
      FileUtils::mv(p4_back, p4_path)
    end
  end

  desc "Deploy the application. Option: vhost_dir=<root dir of virtual host>"
  task :deploy_war do
    raise(ArgumentError, "Must give vhost_dir option") unless(ENV['vhost_dir'])
    system('rake assets:package')
    system('warble war:clean')
    system('warble')
    war_name = File.basename(TaskHelper::root_path) + '.war'
    system("cp -v #{war_name} #{File.join(ENV['vhost_dir'], 'ROOT.war')}")
  end

  desc "Update from svn and deploy the WAR file. Options = vhost_dir=<virtual host dir>"
  task :up_and_away => ['update_app', 'deploy_war']


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
            writer = PDF::Writer.new do |pdf|
              book.ordered_pages.each do |page|
                # In order to make the image fit inside the page I have to resize it with this
                # "magic number" (0.85), because the original pages doesn't have the same proportion
                # of the A4 format.
                # This means to have (for now) ugly and wide white borders.
                # TODO find the right way to pack the images
                image = page.orignal_image
                pdf.image(image.file_path, :justification => :center, :resize => 0.85) if(image)
              end
            end
            filename = File.join(Dir.tmpdir, "#{rand 10E16}.pdf")
            writer.save_as(filename)
            pdf_data = TaliaCore::DataTypes::PdfData.new(:source_id => book.id)
            pdf_data.create_from_file('', filename, true) # set to delete tempfile on create
            pdf_data.save!
          end

          logger.info("[#{Time.now.to_s(:long)}] #{title.titleize} generated in %.2f secs" % elapsed)
        end
      end
      
      desc "Create PDF for books and single Facsimile objects."
      task :stuff => :prepare do
        require 'pdf/writer'
        logger = TaliaCore::Source.logger

        # First go through the books
        books = TaliaCore::Book.find(:all)
        facsimiles = TaliaCore::Facsimile.find(:all)

        puts "Processing #{facsimiles.size} facsimiles from #{books.size} books"

        progress = ProgressBar.new("PDF creation", facsimiles.size)

        created = 0
        blank = 0
        book_pages = 0

        books.each do |book|
          logger.info "[#{Time.now.to_s(:long)}] Generating for book #{book.uri.local_name}"
          copyright_info = book.dcns::rights.first || ''
          book_sig = book.siglum || book.uri.local_name

          book_writer = PDF::Writer.new
          pdf_data_book = TaliaCore::DataTypes::PdfData.new(:source_id => book.id)
          pdf_data_book.create_from_writer(:paper => 'A4') do |book_writer|
            pages = book.ordered_pages.elements
            puts "WARNING: Book with no pages #{book.uri}" if(pages.size == 0)
            pages.each do |page|
              facs = page.manifestations(TaliaCore::Facsimile)
              facs.each do |f|
                page_position = page.hyper::position_name.first || page.hyper::position.first
                page_line = "Page #{page.siglum} (#{page_position} from #{book_sig})"
                TaskHelper::create_facsimile_pdf(f, copyright_info, page_line) ? (created += 1) : (blank += 1)
                if(f.has_type?(N::HYPER.Color) && (image = f.original_image))
                  pos_line = "#{book_sig} - page #{page_position} (#{page.siglum})"
                  TaskHelper::write_facs_pdf(book_writer, image, pos_line, book.uri.to_s, copyright_info)
                  book_writer.start_new_page
                  book_pages += 1
                end
                progress.inc if(facsimiles.delete(f))
              end
            end
          end
          pdf_data_book.save!
        end

        # Now for the rest of the facsimiles
        facsimiles.each do
          |f| TaskHelper::create_facsimile_pdf(f) ? (created +=1) : (blank += 1)
          progress.inc
        end
        
        progress.finish
        puts "Done. Found #{created} facsimiles with images and #{blank} without. Created #{book_pages} book pages."
      end
    end

    desc "Clear both generated PDF books and pages"
    task :clear => :prepare do
      pdf_path = File.join(DATA_PATH, 'PdfData', "*", "*.pdf")
      logger = TaliaCore::Book.logger
      logger.info "[#{Time.now.to_s(:long)}] deleting all generated PDF"

      elapsed = Benchmark.realtime do
        TaliaCore::DataTypes::PdfData.destroy_all
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

namespace :sophiavision do
  namespace :import do
    desc "Import from Sophiavision CSV file. Options csvfile=<file> [thumbnail_directory=<dir>] [encoding=MAC]"
    task :csv => 'discovery:disco_init' do
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
  end

  desc "Fix Sophiavision URI encoding for existing sources."
  task :fix_uris => 'discovery:disco_init' do
    { 'AvMedia' => 'av_media_sources',
      'Series'  => 'series',
      'Keyword' => 'keywords'
    }.each { |type, path| fix_uris_for type, path }
  end
end

def fix_uris_for(type, path)
  "TaliaCore::#{type}".constantize.find(:all).each do |source|
    uri = N::LOCAL + "#{path}/" + UriEncoder.normalize_uri(source.uri.local_name)
    puts uri
    source.update_attribute('uri', uri)
  end
end
