class WidgeonController < ApplicationController

  # GET /sources
  # GET /sources.xml
  def index
    raise(NoMethodError, "Not implemented for now")
  end

  # GET information on a widget. If the special "id" <tt>callback</tt> is passed,
  # handle this call as a remote callback for the widget.
  def show
   raise(NoMethodError, "Not implemented for now.")
  end
  
  # Handles "remote calls" to a widget. These are expected to be a AJAX calls,
  # and the widget will use the given callback renderer to modifiy the page
  # using javascript.
  #
  # The widget object itself will be initialized, but the <tt>before_render</tt>
  # method will *not* be called on the widget.
  def callback
    options = WidgeonEncoding.decode_options(params[:call_options])
    
    if(request.xhr?)
      javascript_render(options)
    else
      fallback_reload(options)
    end
  end
  
  # Renders "static" content from the widgets directory. The mime type will be
  # assigned using the file extension and Rails internal MIME table. Note that
  # the Mime type needs to be set up in the Rails configuration if this needs
  # to serve MIME types not preconfigured with Rails (notably images).
  #
  # If the MIME type can not be determined, this will use default type 
  # (application/octet-stream).
  # 
  # If the Widgeon framework is set to serve assets from a static host, this
  # will forward to the respective directory
  def load_file
    if(Widgeon::Widget.asset_mode == :install)
      redirect_path = ''
      redirect_path << widget.web_path_to_public(params[:widgeon_id]) << '/' 
      redirect_path << params[:file]
      redirect_to(redirect_path, :status => :moved_permanently)
    else
      # First, extract the filename and extension
      extension = File.extname(params[:file]).gsub(/^\./, '' )
      widget_klass = Widgeon::Widget.load_widget(params[:widgeon_id])
      file = widget_klass.path_to_static_file(params[:file]) # Get just the "local" filename. 
      
      raise(Widgeon::ResourceNotFound, "Cannot find #{file}") unless(File.exists?(file))
      
      # We try to lookup the mime type from Rails' internal list
      mime_type = Mime::Type.lookup_by_extension(extension)
      
      # Options for the send operation
      send_options = { :disposition => 'inline' }
      
      # Set the mime type if it exists. The Mime type exists if there there is
      # a matching constant definition on the Mime module
      if(Mime.const_defined?(mime_type.to_sym.to_s.upcase))
        send_options[:type] = mime_type.to_s
      end
      
      # Now send the file
      send_file(file, send_options)
    end
  end
  
  # Used for loading a file 
  
  private
  
  # This handles the setup for an xhr/AJAX rendering of the widget
  def javascript_render(options)
    options[:callback_active] = true
    @klass = options.delete(:widget_class).to_s
    raise(ArgumentError, "Must have id for javascript callback") unless(options[:widget_id])
    @options = options
    # Get the action handlers from the options
    @refresh = options.delete(:refresh)
    @javascript = options.delete(:javascript)
    if((@refresh && @javascript) || !(@refresh || @javascript))
      raise(ArgumentError, "Must have exactly one action specifier.")
    end
    raise(ArgumentError, "Unknown widget #{@klass}") unless(Widgeon::Widget.exists?(@klass))
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
