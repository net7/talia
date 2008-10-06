module TaliaCore
  module DataTypes
    
    # Subclass for links to Quicktime MP4 windows media files
    class Mp4Media < MediaLink
      def set_mime_type
        self.mime = 'video/mp4'
      end
    end
  end
end