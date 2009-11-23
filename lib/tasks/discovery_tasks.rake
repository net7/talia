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

KEYWORD_PREFIX = "talia.keywords.".freeze

namespace :discovery do  
  desc "Init for this tasks"
  task :disco_init do # => 'talia_core:talia_init' do
    unless(@talia_is_init)
      require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
      TaskHelper::load_consts
      @talia_is_init = true
    end
  end
  
  desc "Clear all the data (files and data store) if this instance."
  task :clear_all => 'talia_core:clear_store' do
    Util::clear_data
    puts "Attention! Data and iip director were removed! Remember to change the permissions for production."
    Util::setup_ontologies
  end


  desc "Export given language to csv file. Options language=<iso 639.1 lang code> [file=<filename>] [encoding=MAC] [separator=;] [linebreak={MAC|WIN}]"
  task :export_language => :disco_init do
    language = TaskHelper.language_for(ENV['language'])
    ic = TaskHelper.iconv_for(ENV['encoding'], 'UTF-8')
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
  
  desc "Import data and prepare the test server. Downloads data directly from the net."
  task :setup_testserver => [:prep_testserver, :hyper_import, :create_color_facsimile_edition]
  
  desc "Import XML data as a background task. This adds some discovery-specific flavours to the base import"
  task :xml_background_import do
    TaskHelper::prepare_import
    TaskHelper::background_job('xml_import', :tag => 'import')
  end
  
  desc "Command line import. See disco_import_background."
  task :xml_import => :disco_init do
     TaskHelper::prepare_import
     importer = TaliaUtil::ImportJobHelper.new(STDOUT, TaliaUtil::BarProgressor)
     importer.do_import
  end

  desc "Europeana command line import."
  task :europeana_import => :disco_init do
    TaskHelper::prepare_import_for_europeana
    importer = TaliaUtil::ImportJobHelper.new(STDOUT, TaliaUtil::BarProgressor)
    importer.do_import
  end
  
  # Import from Hyper
  desc "Import data from Hyper. Options: base_url=<base_url> [list_path=?get_list=all] [doc_path=?get=] [extension=] [user=<username> password=<pass>] [prepared_images=<directory>]"
  task :hyper_import => :disco_init do
    ENV['reset_store'] = 'yes'
    TaskHelper::background_job('hyper_import_xml_old', :tag => 'import')
    puts "Old-style hyper XML import queued. Will run as a background task."
  end
  
  # creates a facsimile edition and adds to it all the color facsimiles found in the DB
  desc "Creates a Facsimile Edition with all the available color facsimiles. Options nick=<nick> name=<full_name> header=<header_image_folder> catalog=<catalog_siglum>"
  task :create_color_facsimile_edition => :disco_init do
    TaskHelper::edition_config # Setup the configuration
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
      # Copy position from catalog to edition
      fe.position = catalog.position if(catalog.position)
      TaskHelper::setup_header_images
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
            facsimile.write_predicate_direct(N::HYPER.manifestation_of, new_page)
            facsimiles += 1
            progress.inc
          end
        end
      end
    end
    puts "Edition created with #{facsimiles} facsimiles. Creation time: %.2f" % elapsed
  end
  
  
  desc "Creates a Critical Edition with all the HyperEditions related to any subparts of any book in the default catalog. Options nick=<nick> name=<full_name> header=<header_directory> catalog=<catalog_siglum> [version=<version>]"
  task :create_critical_edition => :disco_init do
    TaliaCore::Book
    TaliaCore::Page
    TaliaCore::Chapter
    TaliaCore::Paragraph
    TaliaCore::TextReconstruction
    TaliaCore::Transcription
    TaliaCore::HyperEdition

    TaskHelper::edition_config # Setup the configuration

    version = ENV['version']

    if ENV['catalog'].nil? 
      catalog = TaliaCore::Catalog.default_catalog
    else
      assit(TaliaCore::Catalog.exists?(N::LOCAL + ENV['catalog'])) 
      catalog = TaliaCore::Catalog.find(N::LOCAL + ENV['catalog']) 
    end
    ce = TaskHelper::create_edition(TaliaCore::CriticalEdition, version)
    ce.position = catalog.position if(catalog.position) # Duplicate the position of the catalog on the edition
    TaskHelper::setup_header_images
    
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
        TaskHelper::handle_exception("Exception cloning page #{orig_page.uri}") do
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
        end
      end
      
      # Now clone the chapters on the book      
      book.chapters.each do |chapter|
        TaskHelper::handle_exception("Error cloning chapter #{chapter}") do
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
        end
      end          
      new_book.chapters.each do |chapter|
        chapter.order_pages!
      end
      TaskHelper::handle_exception("Error creating html for #{new_book.uri}") do
        new_book.create_html_data!(version)
      end
    end
  end

  # When using the following task for recreating a Critical edition text, you must
  # use the "full" catalog, that is, including the "texts/" part. e.g. : catalog=texts/Bruno
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
  
  
  
  
  desc "Upload data into eXist database. Option: [contribution_uri=<contribution_uri> feeder=<boolean> autocomplete=<boolean>] (if no contribution is specified, upload all contributions. feeder and/or autocomplete set feeder/autocomplete upload (default is true))"
  task :feeder_upload => :disco_init do
    
    feeder = Feeder.new
    
    if ENV['contribution_uri'].nil? || ENV['contribution_uri'] == ""
    
      contributions = TaskHelper::contributions
    
      progress_size ||= contributions.size
      puts "Processing #{progress_size} contributions (#{progress_size} elements to process)..."
      progress = ProgressBar.new('Contributions', progress_size)
      contributions.each do |contribution|
        TaskHelper::handle_exception("Error feeding contribution #{contribution.uri}") do
          feeder.feed_contribution(contribution.uri) unless ENV['feeder'] == "false"
          Word.add_contribution(contribution.uri) unless ENV['autocomplete'] == "false"
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
    system('git pull')
    if(update_p4)
      puts "Restoring p4 dir"
      FileUtils.rm_rf(p4_path)
      FileUtils::mv(p4_back, p4_path)
    end
  end

  desc "Deploy the application. Option: vhost_dir=<root dir of virtual host> [restart_tomcat=(true|false)]"
  task :deploy_war do
    raise(ArgumentError, "Must give vhost_dir option") unless(ENV['vhost_dir'])
    puts "Backing up locally customized css files"
    system('rake assets:package')
    system('warble war:clean')
    system('warble')
    war_name = File.basename(TaskHelper::root_path) + '.war'
    system("cp -v #{war_name} #{File.join(ENV['vhost_dir'], 'ROOT.war')}")
    if(ENV['restart_tomcat'] && %w(true yes).include?(ENV['restart_tomcat'].downcase))
      puts "Restarting Tomcat server now (only works for Mac OS Leopard Server as root)"
      system("kill `cat /Library/Tomcat/logs/tomcat.pid`")
    end
  end

  desc "Update from svn and deploy the WAR file. Options = vhost_dir=<virtual host dir>"
  task :up_and_away => ['update_app', 'deploy_war']


  # Everything that has to do with the custom templates
  namespace :templates do
    
    desc "Load the xslt from the file system into the database as custom templates"
    task :setup_xslt => :disco_init do
      files = FileList.new("#{TALIA_ROOT}/xslt/**/*.xsl")
      files.each do |xsl_file|
        puts "Importing #{xsl_file}"
        file_content = File.open(xsl_file) { |io| io.read }
        file_content.gsub!(/(<xsl:include\s+href\s*=\s*['|"])(.*)\.xslt?(['|"]\s*\/>)/, "\\1#{N::LOCAL}custom_templates/xslt/\\2\\3")
        template = CustomTemplate.new(:name => File.basename(xsl_file, '.xsl'), 
        :content => file_content, :template_type => 'xslt')
        template.save!
      end
    end
    
    desc "Load the customizable css into the database as custom templates."
    task :setup_css => :disco_init do
      files = FileList.new("#{TALIA_ROOT}/customization_files/customizable_css/*.css")
      files.each do |css_file|
        puts "Importing #{css_file}"
        file_content = File.open(css_file) { |io| io.read }
        file_content = '/* Template from empty file */' if(!file_content || file_content == '')
        template = CustomTemplate.new(:name => File.basename(css_file, '.css'),
          :content => file_content, :template_type => 'css')
        template.save!
      end
    end
    
    desc "Delete all custom xslt files from the database"
    task :clear_xslt => :disco_init do
      CustomTemplate.delete_all(:template_type => 'xslt')
    end
    
    desc "Delete all custom css files from the database"
    task :clear_css => :disco_init do
      CustomTemplate.delete_all(:template_type => 'css')
    end
    
    desc "Delete all custom templates from the database"
    task :clear => :disco_init do
      CustomTemmplate.delete_all
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
  namespace :normalize do
    desc "Normalize all the translations keys for all the keywords on the system according to the Keyword#keyword_value."
    task :keywords => "discovery:disco_init" do
      Globalize::ViewTranslation.find_by_sql("SELECT * FROM globalize_translations WHERE type = 'ViewTranslation' AND tr_key LIKE 'talia.keywords.%'").each do |keyword|
        key = normalized_keyword_key(keyword)
        keyword.update_attribute("tr_key", key) if key
      end
    end
  end

  namespace :import do
    desc "Import from Sophiavision CSV file. Options csvfile=<file> [thumbnail_directory=<dir>] [encoding=MAC]"
    task :csv => 'discovery:disco_init' do
      row_count = 0
      TaskHelper.each_row_from_csv do |row|
        row_count += 1
        if(row.size > 9)
          TaskHelper::media_from_row(row, ENV['thumbnail_directory'])
          print '.'
        else
          print '_'
        end
      end
      puts "\ndone"
    end

    desc "Import keywords from CSV file. Options csvfile=<file>"
    task :keywords => "discovery:disco_init" do
      languages = %w(italian english german french)
      languages.each do |language|
        instance_eval <<-END
          @#{language}_id = Globalize::Language.find_by_english_name("#{language.titleize}").id
        END
      end

      TaskHelper.each_row_from_csv do |row|
        italian, english, german, french = row.compact.map { |translation| translation.gsub("\n", "").strip }
        key = Globalize::ViewTranslation.find_by_sql("SELECT * FROM globalize_translations WHERE type = 'ViewTranslation' AND language_id = #{@italian_id} AND text = '#{italian.titleize}'").tr_key rescue nil

        unless key
          key = "talia.keywords.#{italian.titleize.downcase}"
          puts "Creating missing key for: #{italian.titleize} (#{key})"
        end

        key = normalized_keyword_key(key)
        languages.each do |language|
          instance_eval <<-END
            translation = Globalize::ViewTranslation.find_or_create_by_language_id_and_tr_key_and_pluralization_index(@#{language}_id, key, 1)
            translation.update_attribute("text", #{language}.titleize) unless translation.text == #{language}.titleize
          END
        end if key
      end
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

def normalized_keyword_key(keyword)
  return unless keyword

  keyword = case keyword
  when String
    keyword
  when Globalize::ViewTranslation
    keyword.tr_key
  end

  key = keyword.gsub(KEYWORD_PREFIX, "").strip.titleize.gsub(".", "+").gsub(" ", "+")
  keyword = TaliaCore::Keyword.find_by_sql("SELECT * FROM active_sources WHERE type = 'Keyword' AND uri LIKE '%#{key}' LIMIT 1").first
  if keyword
    key = keyword.keyword_value
  else
    key = nil
  end

  key ? "#{KEYWORD_PREFIX}#{key}" : nil
end
