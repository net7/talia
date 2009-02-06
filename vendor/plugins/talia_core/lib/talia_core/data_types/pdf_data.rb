module TaliaCore
  module DataTypes

    # Class to manage PDF data type
    class PdfData < FileRecord
     
      # return the mime_type for a file
      def extract_mime_type(location)
        'application/pdf'
      end

      # Create the PDF data from a PDF writer. This method needs a block
      # which will be called with the writer object
      def create_from_writer(writer_opts = {})
        activate_pdf
        writer = PDF::Writer.new(writer_opts) do |pdf|
          yield(pdf)
        end
        filename = File.join(Dir.tmpdir, "#{rand 10E16}.pdf")
        writer.save_as(filename)
        self.create_from_file('', filename, true) # set to delete tempfile on create
        self
      end

      private

      # Little helper method - no need to load the pdf classes unless needed,
      # but if called every time round it will slow things down (in Rails it will).
      def self.activate_pdf
        return if(@pdf_active)
        require 'pdf/writer'
        @pdf_active = true
      end

      def activate_pdf
        self.class.activate_pdf
      end

    end
    
  end
end
