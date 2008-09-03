  
require 'rexml/document'
require 'talia_core/data_types/file_store'

module TaliaCore

  # Refers to a transcription of a Work subpart
  class Edition < HyperEdition
    
    def to_html(version=nil, layer=nil)
      
      require 'JXslt/jxslt'
      xalan = JXslt::Xalan.new

      infile = self.data[0].get_file_path
      output = ''
      case self.hyper.file_content_type[0]
      when "hnml"
        max_layer = hnml_max_layer
        middle_output = ''     
        if max_layer != '' 
          shown_layer = layer.nil? ? max_layer : layer
          transformer_parameters = {'layer' => shown_layer}
        end
        xsl = 'public/xsl/hnml/edition_hnml_linear.xsl'
        middle_output = xalan.transform(xsl, infile, nil, options = {:in => "stream", :out => "string", :transformer_parameters => transformer_parameters})
        xsl = 'public/xsl/hnml/edition_hnml_linear_2.xsl'
        output = xalan.transform(xsl, middle_output, nil, options = {:in => "string", :out => "string", :transformer_parameters => transformer_parameters})
      when "TEI"
        
        xsl = 'public/xsl/TEI/p4/html/tei.xsl'
        output = xalan.transform(xsl, infile, nil, options = {:in => "stream", :out => "string"})
      when "WitTEI"
        xsl = 'public/xsl/WitTEI/wab-transform.xsl'
        output = xalan.transform(xsl, infile, nil, options = {:in => "stream", :out => "string"})          
      end
      output
    end
   
  end
end