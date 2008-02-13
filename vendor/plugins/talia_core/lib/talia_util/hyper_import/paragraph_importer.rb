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
            assit_fail("Error #{e} during relation import, possibly malformed XML?")
          end
        end
      end
      
      # Creates a new note with the given information
      def create_note(page, position, coordinates)
        assit(page && position, "Must have page and position to create note")
        return unless(page && position)
        # Create a name for the note's source
        note_name = N::LOCAL + "#{source.uri.local_name}-note#{position}"
        # Check if the note already exists - this should never happen!
        if(!TaliaCore::Source.exists?(note_name))
          note = get_source(note_name, N::HYPER + 'Note')
          note.hyper::position = position
          # Add a relation to the page
          add_source_rel(N::HYPER::page, page, note)
          
          # Create a data object for the coordinates
          if(coordinates && coordinates != '')
            coord_data = TaliaCore::SimpleText.new
            # Create a somewhat unique filename for the coordinates
            coord_file_location = "#{note_name.to_name_s.gsub(/\W/, '+')}-coords.txt"
            coord_data.create_from_data(coord_file_location, coordinates)
            note.data_records << coord_data
          end
          
          @source.hyper::note << note
        else
          assit_fail("Duplicate note #{note_name}")
        end
      end
      
    end
    
  end
  
end
