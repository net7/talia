module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class ParagraphImporter < Importer
      
      source_type 'hyper:Paragraph'
      
      def import!
        import_nodes
      end
      
      # Imports the notes into the source
      def import_nodes
        @element_xml.root.elements.each('notes/note') do |note|
          begin
            page = note.elements['page'].text.strip
            position = note.elements['position'].text.to_i
            coordinates =  note.elements['coordinates'].text
            
            # Create the new note
            create_note(page, position, coordinates)
            
          rescue RuntimeError => e
            assit_fail("Error '#{e}' during relation import, possibly malformed XML?")
          end
        end
      end
      
      # Creates a new note with the given information
      def create_note(page, position, coordinates)
        assit(page && position, "Must have page and position to create note")
        return unless(page && position)
        # Create a name for the note's source
        position = select_position(position)
        n_name = note_name(position)
        # Check if the note already exists - this should never happen!
        if(!TaliaCore::Source.exists?(n_name))
          note = get_source(n_name.local_name, N::HYPER + 'Note')
          # positions are dealt with as if they were strings, we add some leading zeros to be able
          # to order on them even if they are strings
          note.hyper::position << ('000000' + position.to_s)[-6..-1]
          # Add a relation to the page
          add_source_rel(N::HYPER::page, page, note)
          # TODO: Cannot be part_of, check if this causes trouble
          # add_source_rel(N::HYPER::part_of, page, @source)
          # Create a data object for the coordinates
          if(coordinates && coordinates != '')
            coord_data = TaliaCore::DataTypes::SimpleText.new
            # Create a somewhat unique filename for the coordinates
            coord_file_location = "#{n_name.to_name_s.gsub(/\W/, '+')}-coords.txt"
            coord_data.create_from_data(coord_file_location, coordinates)
            note.data_records << coord_data
          end
          
          @source.hyper::note << note
          note.save!
        else
          assit_fail("Duplicate note #{n_name}")
        end
      end
      
      private
      
      # Selects a name for the given note, updating the position until a 
      # "free" position is found. (The original Hyper may include duplicate
      # positions due to incorrect assignments). This returns the new position
      def select_position(initial_position)
        position = initial_position
        while(TaliaCore::Source.exists?(note_name(position))) do position += 1 end
        $stderr.puts("WARNING: Had to adapt note #{initial_position} for #{source.uri.to_name_s} to #{position}") if(position != initial_position)
        position
      end
      
      # Creates a name for a note
      def note_name(position)
        N::LOCAL + "#{source.uri.local_name}-note#{position}"
      end
      
    end
    
  end
  
end
