  
require 'rexml/document'
require 'talia_core/data_types/file_store'

module TaliaCore

  # Refers to a transcription of some other object
  class Edition < HyperEdition
    
    def to_html
      self.data[0].get_content :xsl_file => '/xsl/edition_hnml_linear.xsl'
    end
    
  end
  
  private
  
  # execute xslt transformation
  # * document: xml document. Can be file path as string or REXML::Document
  # * xsl_file: xsl file for transformation. Can be file path as string or REXML::Document  

  def xslt_transform(document, xsl_file)
    xslt = XML::XSLT.new()
    # get xml document
    xslt.xml = document
    # get xslt document
    xslt.xsl = xsl_file

    # return transformation output
    return xslt.ser
  end
        
  
end
