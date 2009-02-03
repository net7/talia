require 'JXslt/jxslt'

unless defined? TaliaCore::XSLT_ROOT
  TaliaCore::XSLT_ROOT = "#{RAILS_ROOT}/public/xslt"
  # when deploying in Tomcat, the content of the public directory is copied outside the RAILS_ROOT
  TaliaCore::XSLT_ROOT = "#{RAILS_ROOT}/../xslt" unless File.exists?(TaliaCore::XSLT_ROOT)
end
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
      saxon = JXslt::Saxon.new
      xsl = "#{XSLT_ROOT}/hnml/get_max_layer.xsl"
      saxon.transform(xsl, @in_xml, nil, options = {:in => "string", :out => "string"})
    end

    protected

    def prepare_transformation(xml, format)
      if xml
        @in_xml = xml
        @format = format
      else
        file = File.open(self.data[0].file_path, 'r')
        @in_xml = file.read
        file.close
        @format = self.dcns::format.first
      end
    end

    def perform_transformation(xsl, xml, transformer_parameters=nil)
      saxon = JXslt::Saxon.new
      output = saxon.transform(xsl, xml, nil, options = {:in => "string", :out => "string", :transformer_parameters => transformer_parameters})
    end

  end
end
