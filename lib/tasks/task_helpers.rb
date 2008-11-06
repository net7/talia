require 'cgi'
require 'fileutils'

class TaskHelper
  
  # Returns a preset RDF query that will select all books that have pages
  # in the default catalog. The books are referred to by :book and the
  # pages by :page. 
  # You may add additional conditions to this query before executing
  def self.default_book_query
    qry = Query.new(TaliaCore::Book).select(:book).distinct
    qry.where(:book, N::RDF.type, N::HYPER.Book)
    # only select from the default catalog
    qry.where(:book, N::HYPER.in_catalog, TaliaCore::Catalog.default_catalog)
    qry.where(:page, N::DCT.isPartOf, :book)
    qry
  end
  
  # Returns an RDF query that will find all manifestations of the given card.
  def self.manifestations_query_for(card)
    qry_man = Query.new(TaliaCore::Source).select(:manifestation).distinct
    qry_man.where(:manifestation, N::HYPER.manifestation_of, card)
    qry_man
  end
  
  # Creates a new edition, using the given edition
  # class. This will use the environment variables passed to the rake task
  def self.create_edition(ed_klass)
    raise(ArgumentError, "Edition must be a Catalog type") unless(ed_klass.new.is_a?(TaliaCore::Catalog))
    ed_uri = N::LOCAL +  ed_klass::EDITION_PREFIX + '/' + ENV['nick']
    raise(RuntimeError, "Edition does already exist: #{ed_uri}") if(TaliaCore::ActiveSource.exists?(ed_uri))
    edition = ed_klass.new(ed_uri)
    edition.hyper::title << ENV['name'] 
    edition.save!
    edition
  end
  
  # Count the number of color facsimiles in the given catalog
  def self.count_color_facsimiles_in(catalog)
    facs_q = Query.new(N::URI).select(:facsimile).distinct
    facs_q.where(:facsimile, N::RDF.type, N::HYPER.Facsimile)
    facs_q.where(:facsimile, N::RDF.type, N::HYPER.Color)
    facs_q.where(:facsimile, N::HYPER.manifestation_of, :page)
    facs_q.where(:page, N::DCT.isPartOf, :book)
    facs_q.where(:book, N::HYPER.in_catalog, catalog)
      
    facs_q.execute.size
  end
  
  # Clones the HyperEditions from the original to the target element. This
  # makes HyperEditions that are manifestations of the original also manifestations
  # of the target. 
  def self.clone_hyper_editions(original, destination)
    # Find all HyperEditions that exist on the original paragraph
    ed_qry = manifestations_query_for(original)
    ed_qry.where(:manifestation, N::RDF.type, N::HYPER.HyperEdition)
    # Add the editions to the new paragraph
    ed_qry.execute.each do |edition|
      quick_add_property(edition, N::HYPER.manifestation_of, destination)
    end
  end
  
  # Sets up an edition stylesheet for the edition with the given name
  def self.setup_edition_style(nick)
    File.open(File.join(RAILS_ROOT, 'customization_files', 'edition_styles', 'edition_template.css')) do |io|
      style = io.read.gsub(/#EDITION_NAME#/, nick)
      style_dir = File.join(RAILS_ROOT, 'public', 'stylesheets', 'editions')
      FileUtils.mkdir_p(style_dir)
      File.open(File.join(style_dir, "#{nick}.css"), 'w') do |outfile|
        outfile << style
      end
    end
  end
  
  # Sets up the header images for an edition
  def self.setup_header_images
    raise(ArgumentError, "No nick given") unless(ENV['nick'])
    raise(ArgumentError, "Name of the header image folder not given") unless(ENV['header'])
    head_folder = File.join(RAILS_ROOT, 'customization_files', 'header_images', ENV['header'])
    raise(ArgumentError, "Header image folder not valid.") unless(File.stat(head_folder).directory?)    
    # Copy and adapt the style sheet
    setup_edition_style(ENV['nick'])
    # Copy the images
    files = Dir[File.join(head_folder, '*.{jpg,jpeg,gif,png,tiff,tif}')]
    edition_image_dir = File.join(RAILS_ROOT, 'public', 'images', 'editions')
    FileUtils.mkdir_p(edition_image_dir)
    files.each do |file|
      name = File.basename(file)
      FileUtils.copy(file, File.join(edition_image_dir, "#{ENV['nick']}_#{name}"))
    end
  end
  
  # This will look for the paragraph on the note, clone it if necessary,
  # and add it to the new note.
  def self.handle_paragraph_for(note, new_note, catalog)
    orig_paragraph = note.paragraph
    # Check if the cloned paragraph already exists
    if(TaliaCore::Paragraph.exists?(catalog.concordant_uri_for(orig_paragraph)))
      paragraph = TaliaCore::Paragraph.find(catalog.concordant_uri_for(orig_paragraph))
      quick_add_property(paragraph, N::HYPER.note, new_note)
    else
      paragraph = catalog.add_from_concordant(orig_paragraph)
      clone_hyper_editions(orig_paragraph, paragraph)
      paragraph.hyper::note << new_note
      paragraph.save!
    end
  end
  
  # Returns the count of paragraphs that are attached to books in the given
  # catalog
  def self.count_notes_in(catalog)
    query = Query.new(N::URI).select(:note).distinct
    query.where(:book, N::RDF.type, N::HYPER.Book)
    # only select from the default catalog
    query.where(:book, N::HYPER.in_catalog, catalog)
    query.where(:page, N::DCT.isPartOf, :book)
    query.where(:note, N::HYPER.page, :page)
    query.execute.size
  end
  
  # Quick hack to "quickly" add a new property to the given Source. This
  # will bypass the usual rdf creation routines and simply add the new
  # property both to the db and rdf "manually" (which is quicker than recreating
  # the rdf fully.
  def self.quick_add_property(subject, predicate, object)
    autosave = subject.autosave_rdf?
    subject.autosave_rdf = false if(autosave)
    subject[predicate] << object
    subject.save!
    subject.my_rdf[predicate] << object
    subject.my_rdf.save
    subject.autosave_rdf = autosave
  end
  
  # Loops through the given books (with a progress meter).
  def self.process_books(books, progress_size = nil)
    progress_size ||= books.size
    puts "Processing #{books.size} books (#{progress_size} elements to process)..."
    progress = ProgressBar.new('Books', progress_size)
    books.each do |book|
      yield(book,progress)
    end
    progress.finish
  end
  
  # Loads the constants/classes for the models
  def self.load_consts
    # Require some model classes that should always be present
    %w( source expression_card catalog facsimile_edition critical_edition manifestation book page paragraph note chapter facsimile text_reconstruction transcription av_media ).each do |klass|
      require_dependency "talia_core/#{klass}"
    end
  end
  
  # Creates a AvMedia object from the given csv row (given as an array)
  def self.media_from_row(row, thumbnail_dir)
    series = series_for(row[0])
    author, title, year, length = row[1], row[2], row[3], row[4]
    wmv_file, mp4_file, download_url = row[5], row[6], row[7]
    semantic_flag = row[8]
    category = category_for(row[9])
    keywords = keywords_from(row[10])
    bibliography = row[11]
    abstract = row[12]
      
    element_uri = N::LOCAL + 'av_media_sources/' + CGI::escape(title)
    element = TaliaCore::AvMedia.new(element_uri)
    element.series = series
    element.dcns::creator << author
    element.title = title
    element.dcns::date << year if(year)
    element.play_length = "#{length} h:mm:ss"
    wmv_data = TaliaCore::DataTypes::WmvMedia.new
    wmv_data.location = wmv_file
    mp4_data = TaliaCore::DataTypes::Mp4Media.new
    mp4_data.location = mp4_file
    element.data_records << [wmv_data, mp4_data]
    element.download_url = download_url if(download_url && download_url.strip != '')
    element.category = category
    element.hyper::keyword << keywords
    element.hyper::bibliography << bibliography if(bibliography)
    element.dct::abstract << abstract if(abstract)
    
    image = thumbnail_for(element, mp4_file, thumbnail_dir)
    
    element.save!
    wmv_data.save!
    mp4_data.save!
    image.save!
    
    element
  rescue Exception => e
    puts "Error importing #{row[2]}: #{e.message}"
    raise
  end
  
  # Creates a thumbnail for a media element
  def self.thumbnail_for(element, mp4_url, pic_dir)
    pic_dir ||= '.'
    default_thumb = File.join(TALIA_ROOT, 'public', 'images', 'thumbvideo.jpg')
    thumb_file = default_thumb
    mp4_name = File.basename(mp4_url.split('/').last, '.mp4')
    thumb_file = File.join(pic_dir, mp4_name + '.jpg')
    if(!File.exist?(thumb_file))
      puts("WARNING: Thumbfile not found #{thumb_file} for #{element.uri}")
      thumb_file = default_thumb
    end
    
    # And now create an image for the thumbnail
    img = TaliaCore::DataTypes::ImageData.new
    img.source = element
    img.create_from_file('thumb.jpg', thumb_file, false)
    img
    
  rescue Exception => e
    assert_fail("Problem creating thumbnail for #{element.uri}: #{e.message}")
  end
  
  # Gets keywords for the slash-separated values in the string
  def self.keywords_from(key_string)
    keys  = key_string.split('/').collect do |key_s|
      # Data files sometimes seem to need some cleaning up
      key_s.gsub!(/\s+/, ' ')
      key_s.gsub!("\t", " ")
      key_s.gsub!("\n", " ")
      key_s.strip!
      if(key_s != '')
        TaliaCore::Keyword.get_with_key_value!(key_s)
      else
        nil # This was an empty kw
      end
    end
    # Reject the empty keywords
    keys.reject { |key| key.nil?}
  end
  
  # Creates or gets a series for the given name
  def self.series_for(name)
    create_or_find(name, TaliaCore::Series, 'series') do |ser|
      ser.hyper::name << name
    end
  end
  
  # Creates or get a category for the given name
  def self.category_for(name)
    create_or_find(name, TaliaCore::Category, 'categories') do |cat|
      cat.name = name
    end
  end
  
  # Helper to create or get an element of the given class in the 
  # given 'namespace'. Can inject a block into the 'creation' phase.
  def self.create_or_find(name, klass, namespace)
    uri = N::LOCAL + "#{namespace}/" + CGI::escape(name.strip)
    if(klass.exists?(uri))
      klass.find(uri)
    else
      el = klass.new(uri)
      yield el if(block_given?)
      el.save!
      el
    end
  end
  
  # Get all contributions
  def self.contributions
    qry = Query.new(TaliaCore::Source).select(:contribution).distinct
    qry.where(:contribution, N::RDF.type, :t)
    qry.where(:t, N::RDFS.subClassOf, N::HYPER.Contribution)
    
    qry.execute
  end
  
end
