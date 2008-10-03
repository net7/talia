module TaliaCore
  
  # A note is a part of a paragraph that is competely contained in a single
  # page. A paragraph may consist multiple notes, and the different notes
  # may be on different pages.
  class Note < ExpressionCard
    
    has_rdf_type N::HYPER.Note
    
    singular_property :position, N::HYPER.position
    singular_property :coordinates, N::HYPER.coordinates
    singular_property :page, N::HYPER.page
    
    clone_properties N::HYPER.coordinates
    
    # The paragraph to which this note belongs
    def paragraph
      Paragraph.find(:first, :find_through => [N::HYPER.note, self])
    end
    
  end
  
end
