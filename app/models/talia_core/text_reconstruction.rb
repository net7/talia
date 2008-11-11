  
require 'rexml/document'
require 'talia_core/data_types/file_store'

module TaliaCore

  # Refers to a transcription of a Work subpart
  class TextReconstruction < HyperEdition
    def available_versions
      case self.dcns::format.first
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
    
    def to_html(version=nil, layer=nil)
      # if no version is specified, it takes the first available
      return '' if available_versions.nil?
      version = available_versions[0] if version.nil?
      require 'JXslt/jxslt'
      saxon = JXslt::Saxon.new
      infile = self.data[0].file_path
      output = ''
      if File.exist?(infile)
        begin
          case self.dcns::format.first
          when 'application/xml+hnml'
            max_layer = hnml_max_layer
            middle_output = ''     
            if max_layer != '' 
              shown_layer = layer.nil? ? max_layer : layer
              transformer_parameters = {'layer' => shown_layer}
            end
            xsl = 'public/xsl/hnml/edition_linear.xsl'
            middle_output = saxon.transform(xsl, infile, nil, options = {:in => "stream", :out => "string", :transformer_parameters => transformer_parameters})
            xsl = 'public/xsl/hnml/edition_linear_2.xsl'
            output = saxon.transform(xsl, middle_output, nil, options = {:in => "string", :out => "string", :transformer_parameters => transformer_parameters})
          when 'application/xml+tei', 'application/xml+tei-p4', 'application/xml+tei-p5'
            xsl = 'public/xsl/TEI/p4/html/tei.xsl'
            output = saxon.transform(xsl, infile, nil, options = {:in => "stream", :out => "string"})
          when 'application/xml+wit_tei'
            xsl = 'public/xsl/WitTEI/wab-transform.xsl'    
            # visning is the parameter for the version in the wab-transform.xsl file        
            transformer_parameters = {'visning' => version}
            output = saxon.transform(xsl, infile, nil, options = {:in => "stream", :out => "string", :transformer_parameters => transformer_parameters})          
          when 'text/html'
            xsl = 'public/xsl/plain/plain.xsl'
            output = saxon.transform(xsl, infile, nil, options = {:in => "stream", :out => "string", :transformer_parameters => transformer_parameters})          
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