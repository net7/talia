module TaliaCore
  module DataTypes
    
    # Data class that contains just a link to a remote data element (and no
    # locally stored data at all). The uri for the link is stored in the location
    # field
    class MediaLink < DataRecord
      
      def all_bytes
        raise(RuntimeError, "Media Links have no data")
      end
      
      def get_byte(close_after_single_read=false)
        raise(RuntimeRror, "Media Links have no data")
      end
      
    end
  end
end
