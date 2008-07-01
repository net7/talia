class SimpleModeImageWidget < Widgeon::Widget
  
  def on_init
    #TODO: gather image from RDF starting from @page
    @file_path = "img/N-IV-1,1.jpg"
  
    @code = "<img src='#{@file_path}' alt='immagine' width='723' height='488'/>"  

  end
end