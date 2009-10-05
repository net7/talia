require 'yaml'

module TaliaUtil
  
  module HyperImporter
    
    class Importer < TaliaCore::ActiveSourceParts::Xml::GenericReader
      
      include HyperReader
      
      can_use_root
      
      element :source do
        add_source :from_all_sources
      end
      
      element :archive do
        add_default_type 'Archive'
        add_mapped :id
        add_mapped :state
        add_mapped :city
        add_mapped :address
        add_mapped :copyrightnote
        add_defaults false
      end
      
      element :author do
        add :type, 'Person'
        add N::RDF.type, N::HYPER.Author
        add_author_thing 'name'
        add_author_thing 'surname'
        add_author_thing 'status'
        add_author_thing 'institution'
        add_mapped :position
        add_mapped :street
        add_mapped :zip
        add_mapped :city
        add_mapped :country
        add_mapped :telephone
        add_mapped :fax
        add_mapped :email
        add_mapped :webpage
        add_mapped :from_date
        add_mapped :to_date
        add_defaults false
      end
      
      def add_author_thing(property)
        add N::HYPER + ('author_' << property), from_element(property)
      end
      
      element :book do
        add_default_type 'Book'
        add_mapped :copyrightNote
        add_mapped :description
        add_mapped :date
        add_mapped :collocation
        add_mapped :publisher
        add_mapped :publishingPlace
        add_mapped :ordering
        add_defaults
      end
      
      element :catalog do
        add_default_type 'Catalog'
        add_mapped :position
        add_defaults false
      end
      
      element :chapter do
        add_default_type 'Chapter'
        add_mapped :position
        add_mapped :name
        add_mapped_rel :book
        add_mapped_rel :first_page
        add_defaults
      end
      
      element :essay do
        add_default_type 'Essay'
        add_mapped :abstract
        add_contribution_defaults
      end
      
      element :essayPage do
        add_default_type 'EssayPage'
        add_mapped :position
        add_mapped :position_name
        add_hyper_file
        add_defaults false
      end
      
      element :external_object do
        add_default_type 'ExternalObject'
        add_mapped :description
        add_mapped :publication_place
        add_mapped :first_page
        add_mapped :last_page
        add_mapped :journal
        add_mapped :book_collection
        add_mapped :pages
        add_mapped_rel :related_contribution
        add_contribution_defaults
      end
      
      element :facsimile do
        add_default_type 'Facsimile'
        width = from_element :dimensionX
        height = from_element :dimensionY
        add N::DCT.extent, "#{width}x#{height} pixel" if(width && height)
        add_contribution_defaults false
        add N::HYPER.blank_facsimile, 'true' unless(@current.attributes[:files])
      end
      
      element :page do
        add_default_type 'Page'
        add_mapped :position
        add_mapped :position_name
        width = from_element :width
        height = from_element :height
        add N::DCT.extent, "#{width}x#{height} pixel" if(width && height)
        add_defaults
      end
      
      element :paragraph do
        add_default_type 'Paragraph'
        add_defaults false
        notes = []
        nested :notes do
          add_source :note do
            # Get all the elements to create that note
            page = from_element(:page)
            position = from_element(:position)
            assit(page && position, "Must have page and position to create note")
            position = select_position(page, position)
            coordinates = from_element(:coordinates)
            
            note_name = note_name(page, position)
            # The same note should not be created twice
            if(source_exists?(note_name))
              assit(false, 'Duplicate Note')
              next
            end
            add :uri, note_name
            add :type, 'Note'
            # positions are dealt with as if they were strings, we add some leading zeros to be able
            # to order on them even if they are strings
            add N::HYPER.position, ("%06d" % position.to_i)
            add N::HYPER.siglum, note_name.local_name
            add_rel N::HYPER::page, (N::LOCAL + page)
            add N::HYPER.coordinates, coordinates unless(coordinates.blank?)
            notes << note_name # add to the list to add
          end
        end
        notes.each { |note| add_rel N::HYPER.note, note }
      end
      
      # Creates a name for a note
      def note_name(page, position)
        N::LOCAL + "#{page}-note#{position}"
      end
      
      # Selects a name for the given note, updating the position until a 
      # "free" position is found. (The original Hyper may include duplicate
      # positions due to incorrect assignments). This returns the new position
      def select_position(page, initial_position)
        position = initial_position
        while(source_exists?(note_name(page, position))) do position += 1 end
        logger.warn("\033[4m\033[33m\033[1mParagraphImporter\033[0m Had to adapt note #{initial_position} for #{source.uri.to_name_s} on page #{page} to #{position}") if(position != initial_position)
        position
      end
      
      element :path do
        add_default_type 'Path'
        add_mapped :description
        add_contribution_defaults
      end
      
      element :pathStep do
        add_default_type 'PathStep'
        add_mapped :stepDescription
        add_mapped :position
        add_defaults false
      end
      
      element :text_reconstruction do
        add :type, 'TextReconstruction'
        add N::RDF.type, N::HYPER.HyperEdition
        add_contribution_defaults false
      end
      
      element :transcription do
        add :type, 'Transcription'
        add N::RDF.type, N::HYPER.HyperEdition
        add_contribution_defaults false
      end
      
    end
  end
end