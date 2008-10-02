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
    qry.where(:page, N::HYPER.part_of, :book)
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
    facs_q.where(:page, N::HYPER.part_of, :book)
    facs_q.where(:book, N::HYPER.in_catalog, catalog)
      
    facs_q.execute.size
  end
  
  # Clones the HyperEditions from the original to the target element. This
  # makes HyperEditions that are manifestations of the original also manifestations
  # of the target. 
  def self.clone_editions(original, destination)
    # Find all HyperEditions that exist on the original paragraph
    ed_qry = manifestations_query_for(original)
    ed_qry.where(:manifestation, N::RDF.type, N::HYPER.HyperEdition)
    # Add the editions to the new paragraph
    ed_qry.execute.each do |edition|
      quick_add_property(edition, N::HYPER.manifestation_of, destination)
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
      clone_editions(orig_paragraph, paragraph)
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
    query.where(:page, N::HYPER.part_of, :book)
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
    %w( source expression_card catalog facsimile_edition critical_edition manifestation book page paragraph facsimile).each do |klass|
      require_dependency "talia_core/#{klass}"
    end
  end
  
end
