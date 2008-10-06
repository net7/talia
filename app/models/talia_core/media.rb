module TaliaCore
  
  # This refers to a media file in the collection
  class Media < ExpressionCard
    
    clone_properties N::HYPER.play_length,
      N::HYPER.downloadable
    
    singular_property :hyper_category, N::HYPER.category
    singular_property :downloadable, N::HYPER.downloadable
    singular_property :play_length, N::HYPER.play_length

    # Returns the media objects (manifestations of the media object) with the
    # given file type.
    def media(file_type)
      data(file_type.to_s.camelize)
    end
    
    
  end
end
