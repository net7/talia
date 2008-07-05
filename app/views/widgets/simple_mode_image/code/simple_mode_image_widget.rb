class SimpleModeImageWidget < Widgeon::Widget
  
  include TaliaCore

  
  def on_init

    # it looks in the RDF to find a facsimile related to the given @page page
    # TODO: check if the facsimile is in the macrocontribution

    page = Source.find(@page)
    
    fax_uri = page.inverse.[]('http://www.hypernietzsche.org/ontology/cites')

    fax = Source.new(fax_uri)
    
    @code = fax.data

    #    @code = @fax.data(type, location)
 
    # @data = @fax.data
    
    
    
    # @file_path = "img/N-IV-1,1.jpg"

    # @code = "<img src='#{@file_path}' alt='#{@page}' width='723' height='488'/>"  

  end
end