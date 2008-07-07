class SimpleModeImageWidget < Widgeon::Widget
  
  include TaliaCore

  
  def on_init
    # mode can be 'show', 'next' or 'previous'
    case @mode
    when 'show'
      @code = show(@page)
    else
      # both 'previous' and 'next' cases
      @code = move(@page, @mode)
    end

  end
  
  def show(page_uri)
       
    # it looks in the RDF to find a facsimile related to the given @page page
    # TODO: check if the facsimile is in the macrocontribution

    page = Source.find(page_uri)
    
    fax_uri = page.inverse.[]('http://www.hypernietzsche.org/ontology/cites')

    fax = Source.new(fax_uri)
    
    fax.data('ImageData')
    
    file_path = fax.data

    result = "<img src='#{file_path}' alt='#{@page}' width='723' height='488'/>"  

  end
  
  def move(page_uri, movement)
    case movement
    when 'previous'
    when 'next'
    end
    code ="<p class='#{movement}'><a href='#'></a></p>"
  end
end