module TaliaCore
  
  
  # This refers to a media file in the collection
  class Media < ExpressionCard
    
    clone_properties N::HYPER.play_length,
      N::HYPER.downloadable
    
    singular_property :category, N::HYPER.category
    singular_property :downloadable, N::HYPER.downloadable
    singular_property :play_length, N::HYPER.play_length

    # Returns the media objects (manifestations of the media object) with the
    # given file type.
    def media(file_type)
      
    end
    
    
  end
end
