require 'java'
module JXslt
  include_class "javax.xml.transform.TransformerFactory"
  include_class "javax.xml.transform.Transformer"
  include_class "javax.xml.transform.stream.StreamSource"
  include_class "javax.xml.transform.stream.StreamResult"
  include_class "java.lang.System"

  class XsltProcessor
    def transform(xslt,infile,outfile)
      transformer = @tf.newTransformer(StreamSource.new(xslt))
      transformer.transform(StreamSource.new(infile), StreamResult.new(outfile))
    end 
  end # XsltProcessor  
  class Saxon < XsltProcessor
    TRANSFORMER_FACTORY_IMPL = "net.sf.saxon.TransformerFactoryImpl"
    def initialize
      System.setProperty("javax.xml.transform.TransformerFactory", TRANSFORMER_FACTORY_IMPL)
      @tf = TransformerFactory.newInstance
    end 
  end
  class Xalan < XsltProcessor
    TRANSFORMER_FACTORY_IMPL = "org.apache.xalan.processor.TransformerFactoryImpl"
    def initialize
      System.setProperty("javax.xml.transform.TransformerFactory", TRANSFORMER_FACTORY_IMPL)
      @tf = TransformerFactory.newInstance
    end 
  end
end 
