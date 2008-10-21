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
  
  desc "Export given language to csv file. Options language=<iso 639.1 lang code> [file=<filename>]"
  task :export_language => :disco_init do
    language = Globalize::Language.find(:first, :conditions => { :iso_639_1 => ENV['language']})
    unless(language)
      puts "Language #{ENV['language']} not found."
      exit 1
    end
    
    translations = Globalize::ViewTranslation.find(:all, :conditions => ['language_id = ? AND id > 7068', language.id])
    progress = ProgressBar.new('Exporting', translations.size)
    filename = ENV['file'] || "#{ENV['language']}_glob.csv"
    
    File.open(filename, 'w') do |io|
      CSV::Writer.generate(io, ';', "\r") do |csv|
        for trans in translations
          csv << [trans.tr_key, trans.text]
          progress.inc
        end
      end
    end
    progress.finish
  end
  
  desc "Import the given language from the csv file. Options language=<iso 639.1 lang code> [file=<filename>]"
  task :import_language => :disco_init do
    language = Globalize::Language.find(:first, :conditions => { :iso_639_1 => ENV['language']})
    unless(language)
      puts "Language #{ENV['language']} not found."
      exit 1
    end
    filename = ENV['file'] || "#{ENV['language']}_glob.csv" 
    File.open(filename) do |io|
      CSV::Reader.parse(io, ';', "\r") do |row|
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
    end
    puts 'Done'
  end
  
  desc "Import from Sophiavision CSV file. Options csvfile=<file>"
  task :sophia_csv => :disco_init do
    ENV['nick'] = 'default'
    ENV['name'] = 'default'
    CSV::Reader.parse(File.open(ENV['csvfile']), ';', "\r") do |row|
      series = TaskHelper::series_for(row[0])
      author, title, year, length = row[1], row[2], row[3], row[4]
      wmv_file, mp4_file, download = row[5], row[6], row[7]
      category = TaskHelper::category_for(row[8])
      keywords = TaskHelper::keywords_from(row[9])
      bibliography = row[10]
      abstract = row[11]
      
      element_uri = N::LOCAL + 'media_sources/' + CGI::escape(title)
      element = TaliaCore::Media.new(element_uri)
      element.series = series
      element.dcns::creator << author
      element.title = title
      element.dcns::date << year
      element.play_length = length
      wmv_data = TaliaCore::DataTypes::WmvMedia.new
      wmv_data.location = wmv_file
      mp4_data = TaliaCore::DataTypes::Mp4Media.new
      mp4_data.location = mp4_file
      element.data_records << [wmv_data, mp4_data]
      element.downloadable = download
      element.category = category
      element.hyper::keyword << keywords
      element.hyper::bibliography << bibliography if(bibliography)
      element.dcns::abstract << abstract if(abstract)
      element.save!
      wmv_data.save!
      mp4_data.save!
      print '.'
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
      fe.hyper::description << ENV['description']
      qry = TaskHelper::default_book_query
      qry.where(:facsimile, N::HYPER.manifestation_of, :page)
      qry.where(:facsimile, N::RDF.type, N::HYPER + 'Facsimile')
      qry.where(:facsimile, N::RDF.type, N::HYPER + 'Color')
      
      facs_size = TaskHelper::count_color_facsimiles_in(TaliaCore::Catalog.default_catalog)
      
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

  desc "Creates a Critical Edition with all the HyperEditions related to any subparts of any book in the default catalog. Options nick=<nick> name=<full_name> description=<relative path to an HTML file containing the description of the edition (the Front Page)>" 
  task :create_critical_edition => :disco_init do
 
    TaliaCore::Book
    TaliaCore::Page
    TaliaCore::Chapter
    TaliaCore::Paragraph
    TaliaCore::TextReconstruction
    TaliaCore::Transcription
    TaliaCore::HyperEdition
    
    ce = TaskHelper::create_edition(TaliaCore::CriticalEdition)
    # the description page must be passed as a path to the HTML file containing it
    description_file_path = ENV['description']
    ce.create_html_description!(description_file_path)
    
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

    note_count = TaskHelper::count_notes_in(TaliaCore::Catalog.default_catalog)
    notes = 0
    
    TaskHelper::process_books(books, note_count) do |book, progress|
      new_book = book.clone_to(ce) do |orig_page, new_page|
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
          notes += 1
        end
      end
      
      # Now clone the chapters on the book      
      book.chapters.each do |chapter|
        ce.add_from_concordant(chapter) do |cloned_chapt|
          cloned_chapt.book = new_book
          first_page = chapter.first_page.concordant_cards(ce).first
          assit(first_page, "Must have a first page on the chapter #{chapter.uri}.")
          cloned_chapt.first_page = first_page
          cloned_chapt.save!
        end
      end          
      new_book.chapters.each do |chapter|
        chapter.order_pages!
      end
      new_book.create_html_data!
    end
  end
  
  namespace :pdf do
    desc "Create pdf books"
    task :create => [ 'disco_init', 'talia_core:talia_init' ] do
      require 'pdf/writer'
      
      # TODO Should each generated book be a source?
      # In this case, should pdf be placed under 'data/PdfData'?
      pdf_path = File.join(DATA_PATH, 'PdfData')
      FileUtils.mkdir_p pdf_path

      TaliaCore::Book.find(:all).each do |book|
        title = book.uri.local_name
        print title.titleize

        elapsed = Benchmark.realtime do
          PDF::Writer.new do |pdf|
            book.ordered_pages.each do |page|
              # In order to make the image fit inside the page I have to resize it with this
              # "magic number" (0.85), because the original pages doesn't have the same proportion
              # of the A4 format.
              # This means to have (for now) ugly and wide white borders.
              # TODO find the right way to pack the images
              pdf.image page.image_path, :justification => :center, :resize => 0.85
            end
          end.save_as File.join(pdf_path, "#{title}.pdf")
        end

        puts " %.2f" % elapsed
      end
    end
  end
end
