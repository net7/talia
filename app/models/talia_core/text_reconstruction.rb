module TaliaCore

  # Refers to a transcription of a Work subpart
  class TextReconstruction < HyperEdition
    def available_versions(format)
      # this is needed because previews must provide the format, while in normal
      # operations the format is retrieved from the source (which doesn't exist
      # in the preview case)
      @format = self.dcns::format.first if @format.nil?
      case @format
      when 'application/xml+hnml', 'application/xml+gml'
        ['diplomatic']
      when 'application/xml+tei', 'application/xml+tei-p4', 'application/xml+tei-p5'
        ['standard']
      when 'application/xml+wit_tei'
        ['dipl', 'norm', 'study']
      when 'text/html'
        ['standard']
      else
        #FIXME: add a better thing for this after the review        raise(ArgumentError, "Unknown content type for #{self.uri}: #{self.dcns::format.first}")
        nil
      end
    end
    
    def to_html(version=nil, layer=nil, xml=nil, format=nil)
      #fills the @in_xml and the @format vars
      prepare_transformation(xml, format)
      # if no version is specified, it takes the first available
      return '' if available_versions(format).nil? and version.nil?
      version = available_versions(format)[0] if version.nil?
      output = ''
      unless @in_xml.nil?
        begin
          case @format
          when 'application/xml+hnml'
            max_layer = hnml_max_layer
            middle_output = ''     
            if max_layer != '' 
              shown_layer = layer.nil? ? max_layer : layer
              transformer_parameters = {'layer' => shown_layer}
            end
            xsl1 = 'public/xsl/hnml/edition_linear.xsl'
            xsl2 = 'public/xsl/hnml/edition_linear_2.xsl'
            mid_xml = perform_transformation(xsl1, @in_xml, transformer_parameters)
            output = '<div class="hnml">' + perform_transformation(xsl2, mid_xml, transformer_parameters) + '</div>'
          when 'application/xml+tei', 'application/xml+tei-p4', 'application/xml+tei-p5'
            xsl = 'public/xsl/TEI/p4/html/tei.xsl'
            output = '<div class="tei">' + perform_transformation(xsl, @in_xml) + '</div>'
          when 'application/xml+wit_tei'
            xsl = 'public/xsl/WitTEI/wab-transform.xsl'    
            # visning is the parameter for the version in the wab-transform.xsl file        
            transformer_parameters = {'visning' => version}
            output = '<div class="wittei">' + perform_transformation(xsl, @in_xml, transformer_parameters) + '</div>'
          when 'text/html'
            output = @in_xml
          end
        rescue #TODO: handle these specific (java) exception:
          #   net.sf.saxon.trans.XPathException
          #    org.xml.sax.SAXParseException
          output = "XML is Broken!"
        end
      else
        puts "Warning file was missing: #{infile} calculation will continue"  
      end
      output
    end
   
  end
end