class SimpleModeImageWidget < Widgeon::Widget
  
  include TaliaCore

  
  def on_init
      
    # it looks in the RDF to find a facsimile related to the given @page page
    # TODO: check if the facsimile is in the macrocontribution

    page = Source.find(params[:page])
    
    fax_uri = page.inverse.[]('http://www.hypernietzsche.org/ontology/cites')

    fax = Source.new(fax_uri)
    
    file_path = fax.data('ImageData')

    @code = "<img src='#{file_path}' alt='#{params[:page]}' width='723' height='488'/>"  

  end
  
  def move(page_uri, movement)
    case movement
    when 'previous'
    when 'next'
    end
    @code ="<p class='#{movement}'><a href='#'></a></p>"
  end
end