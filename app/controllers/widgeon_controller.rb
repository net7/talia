class WidgeonController < ApplicationController

  # This handles a callback from a widget
  def callback
    widget_class = params[:widget_class]
    widget_options = WidgeonEncoding.decode_object(params[:options])
    
    @widget = Widgeon::Widget.load(widget_class.to_s).new(widget_options)
  end
  
end
