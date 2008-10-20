module TaliaCore
  
  # A super-class which has digital transpositions of the text found on a 
  # material part (page, paragraph, ...) in the real world
  class HyperEdition < Manifestation
    
    def to_html
      assit_fail("Should never call base class version of to_html.")
      # to be overridden by subclasses
    end
    
    def available_layers
      if  self.dcns::format.first == 'application/xml+hnml'
        layers = hnml_max_layer 
      end
      layers
    end
    
    def available_versions
      assit_fail("Should never call base class version of available_versions.")
      # to be overridden by subclasses
    end
      
    # for HNML documents. It uses a special XSL to get the highest "layer" value
    def hnml_max_layer
      require 'JXslt/jxslt'
      saxon = JXslt::Saxon.new
      infile = self.data[0].file_path
      xsl = 'public/xsl/hnml/get_max_layer.xsl'
      saxon.transform(xsl, infile, nil, options = {:in => "stream", :out => "string"})
    end
  
  end
end
