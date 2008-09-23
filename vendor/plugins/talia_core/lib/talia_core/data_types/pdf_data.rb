module TaliaCore
  module DataTypes
    
    # Class to manage PDF data type
    class PdfData < FileRecord
     
      # return the mime_type for a file
      def extract_mime_type(location)
        'application/pdf'
      end
      
    end
    
  end
end
