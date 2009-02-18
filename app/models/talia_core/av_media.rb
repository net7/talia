module TaliaCore
  
  # This refers to a audio video media file in the collection
  class AvMedia < ExpressionCard
    
    has_rdf_type N::HYPER.AvMedia
    
    clone_properties N::DCT.extent,
      N::HYPER.download_url
    
    singular_property :hyper_category, N::HYPER.category
    singular_property :download_url, N::HYPER.download_url
    singular_property :play_length, N::DCT.extent

    # Returns the media objects (manifestations of the media object) with the
    # given file type.
    def media(file_type)
      data(file_type.to_s.camelize)
    end
  end
end
