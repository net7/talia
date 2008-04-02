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
    options = WidgeonEncoding.decode_options(params[:call_options])
    
    
    if(request.xhr?)
      javascript_render(options)
    else
      fallback_reload(options)
    end
  end
  
  
  private
  
  # This handles the setup for an xhr/AJAX rendering of the widget
  def javascript_render(options)
    options[:callback_active] = true
    klass = options.delete(:widget_class).to_s
    @widget = Widgeon::Widget.load_widget(klass).new(self, request, options)
    # Get the action handlers from the options
    @refresh = options.delete(:refresh)
    @javascript = options.delete(:javascript)
    if((@refresh && @javascript) || !(@refresh || @javascript))
      raise(ArgumentError, "Must have exactly one action specifier.")
    end
    @refresh = nil if(@refresh == :default) # Define no template => default
  end
  
  # This handles the "fallback" reload of the original page, in case that his
  # is not a AJAX call
  def fallback_reload(options)
    raise("Fallback reloading not allowed for this call.") unless(options.delete(:fallback_enabled))
    redirect_options = options.delete(:request_params)
    raise(ArgumentError, "Illegal options (#{redirect_options.class})") unless(redirect_options.is_a?(Hash))
    redirect_options[:widgeon_class] = options[:widget_class]
    redirect_options[:widgeon_id] = options[:widget_id]
    redirect_options[:widgeon_callback] = WidgeonEncoding.encode_options(options)
    redirect_to(redirect_options)
  end
  
end
