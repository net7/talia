module TaliaCore
  module DataTypes
    
    # Subclass for links to WMV windows media files
    class WmvMedia < MediaLink
      def set_mime_type
        self.mime = 'video/x-ms-wmv'
      end
    end
  end
end
