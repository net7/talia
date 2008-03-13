class WidgeonController < ApplicationController
  def index
    if request.xhr?
      raise(ArgumentError, "Widget not found") unless Widgeon::Widget.loaded_widgets.include?(params[:widget_name].to_sym) 
      options = {:controller => @controller, :request => request}
      widget  = Widgeon::Widget.create_widget(params[:widget_name], options)
      render :text => widget.send(params[:handler].to_sym, params), :status => 200
    end
  end 

  def stylesheet
    respond_to do |format|
      format.css { render :file => "#{Widgeon::Widget.path_to_widgets}/#{params[:widget]}/#{params[:widget]}.css" }
    end
  end
  
  # This handles a callback from a widget
  def callback
    options = WidgeonEncoding.decode_options(params[:widget_callback_options])
    
    if(request.xhr?)
      # Set the callback flag
      options[:callback_active] = true
      @widget = Widgeon::Widget.load(options[:widget_class].to_s).new(self, request, options)
    else
      redirect_options = options.delete(:request_params)
      raise(ArgumentError, "Illegal options") unless(redirect_options.is_a?(Hash))
      redirect_options[:widgeon_class] = options[:widget_class]
      redirect_options[:widgeon_id] = options[:widget_id]
      redirect_options[:widgeon_callback] = WidgeonEncoding.encode_options(options)
      redirect_to(redirect_options)
    end
  end
end
