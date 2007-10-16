class HelloWorldWidget < Widgeon::Widget
  
  def before_render
    @world_text = "Hello World"
  end
end
