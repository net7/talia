class CriticalEditionMenuWidget < Widgeon::Widget
  
  # This will run during the widget initialization. You can use all options
  # for the widget as class variables, and all class variables that
  # you set will be available as accessors in the template.
  def on_init
   books = @books
  end
  
  # Example callback for javascript
  # callback :first_callback do |page|
  #   page.insert_html(options)
  # end
end