module TaliaCore
  
  # Refers to a transcription of a Manuscript subpart
  class Transcription < HyperEdition
    
    
    def available_versions
      case self.dcns::format.first
      when 'application/xml+hnml'
        ['linear', 'diplomatic']
      when 'application/xml+tei'
        ['standard']
      when 'application/xml+wit_tei'
        ['norm', 'dipl', 'study']
      else
        raise(ArgumentError, "Unknown content type for#{self.uri}: #{self.dcns::format.first}")
      end
    end
    
    
    def to_html(version=nil, layer=nil)
      # if no version is specified, it takes the first available
      version = available_versions[0] if version.nil?
      require 'JXslt/jxslt'
      saxon = JXslt::Saxon.new
      infile = self.data[0].file_path
      output = ''
      begin
        case self.dcns::format.first
        when 'application/xml+hnml'
          case version
          when 'diplomatic'
            xsl1 = 'transcription_diplomatic.xsl'
            xsl2 = 'transcription_diplomatic_2.xsl'
          when 'linear'   
            xsl1 = 'transcription_linear.xsl'
            xsl2 = 'transcription_linear_2.xsl'
          end
          max_layer = hnml_max_layer
          middle_output = ''       
          if max_layer != '' 
            shown_layer = layer.nil? ? max_layer : layer
            transformer_parameters = {'layer' => shown_layer}
          end
          xsl = 'public/xsl/hnml/' + xsl1
          middle_output = saxon.transform(xsl, infile, nil, options = {:in => "stream", :out => "string", :transformer_parameters => transformer_parameters})
          xsl = 'public/xsl/hnml/' + xsl2 
          output = saxon.transform(xsl, middle_output, nil, options = {:in => "string", :out => "string", :transformer_parameters => transformer_parameters})
        when 'application/xml+tei'
          xsl = 'public/xsl/TEI/p4/html/tei.xsl'
          output = saxon.transform(xsl, infile, nil, options = {:in => "stream", :out => "string"})
        when 'application/xml+wit_tei'
          xsl = 'public/xsl/WitTEI/wab-transform.xsl'
          # visning is the parameter for the version in the wab-transform.xsl file
          transformer_parameters = {'visning' => version}
          output = saxon.transform(xsl, infile, nil, options = {:in => "stream", :out => "string", :transformer_parameters => transformer_parameters})
        end
      rescue #TODO: handle these specific (java) exception: 
        #   net.sf.saxon.trans.XPathException
        #    org.xml.sax.SAXParseException
        output = "XML is Broken!"
      end
      output
    end
  end
end
