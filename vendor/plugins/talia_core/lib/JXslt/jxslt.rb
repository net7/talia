require 'java'
module JXslt
  include_class "javax.xml.transform.TransformerFactory"
  include_class "javax.xml.transform.Transformer"
  include_class "javax.xml.transform.stream.StreamSource"
  include_class "javax.xml.transform.stream.StreamResult"
  include_class "java.lang.System"

  class XsltProcessor

    def transform(xslt, infile, outfile, options)
      if options[:in] == "stream"
        in_var = StreamSource.new(infile)
      else
        sr = java.io.StringReader.new(infile)
        in_var =  StreamSource.new(sr)
      end
      if options[:out] == "stream"
        out_var = StreamResult.new(outfile)
      else
        sw = java.io.StringWriter.new()
        out_var = StreamResult.new(sw)
      end
      transformer = @tf.newTransformer(StreamSource.new(xslt))
      unless options[:transformer_parameters].nil?
        options[:transformer_parameters].each do |key, value|
            transformer.setParameter(key, java.lang.String.new(value))
        end
      end
      transformer.transform(in_var, out_var)
      if options[:out] != "stream"
        outfile = sw.toString()
      end
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
