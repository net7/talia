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
  
  # Handles "remote calls" to a widget. These are expected to be a AJAX calls,
  # and the widget will use the given callback renderer to modifiy the page
  # using javascript.
  #
  # The widget object itself will be initialized, but the <tt>before_render</tt>
  # method will *not* be called on the widget.
  def remote_call
    render("Can only be called as AJAX.", :status => 400) unless(request.xhr?)
    options = WidgeonEncoding.decode_options(params[:call_options])
    options[:callback_active] = true
    widget_class = options.delete(:widget_class).to_s
    # Action is the action that will be called on the widget.
    @action = options.delete(:template)
    @widget = Widgeon::Widget.load(widget_class).new(self, request, options)
  end
  
  # This handles a callback from a widget to itself
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
