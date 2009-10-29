  require 'JXslt/jxslt'

unless defined? TaliaCore::XSLT_ROOT
  TaliaCore::XSLT_ROOT = "#{RAILS_ROOT}/xslt"
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
      perform_transformation('get_max_layer', @in_xml)
    end

    protected

    def prepare_transformation(xml, format)
      if xml
        # we're serving a preview request. Data are sent in POST variables
        @in_xml = xml
        @format = format
      else
        # we're performing a transformation for a real hyperedition source
        file = File.open(self.data[0].file_path, 'r')
        @in_xml = file.read
        file.close
        @format = self.dcns::format.first
      end
    end

    def perform_transformation(xsl, xml, transformer_parameters=nil)
      xsl_object = CustomTemplate.find(:first, :conditions => { :template_type => 'xslt', :name => xsl })
      raise(ArgumentError, "Template not found for xsl transformation: #{xsl}") unless(xsl_object)
      saxon = JXslt::Saxon.new
      output = saxon.transform(xsl_object.content, xml, nil, options = {:in => "string", :out => "string", :xsl => "string", :transformer_parameters => transformer_parameters})
    end

  end
end
