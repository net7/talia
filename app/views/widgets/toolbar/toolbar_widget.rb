class ToolbarWidget < Widgeon::Widget
  
  # This optional callback runs the code before the widget rendering.
  def before_render
  end
  
  def each_button(&block)
    buttons.each do |button|
      name = button[0]
      url = button[1]
      url = case url
      when Hash
        controller.url_for(url)
      else
        url.to_s
      end
      block.call(name, url)
    end
  end
end