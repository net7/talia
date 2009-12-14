class PreviewController < ApplicationController
  #   before_filter :login_required
 
  # Called by Fabrica2, this controller offer an easy way to check out if
  # transcription/text_reconstruction XML codes produce the desired outputs.
  # The users will call this from fabrica, and will see the result of the
  # transformations directly in there (in a html viewer object of FileMaker Pro)
  def index
    
    xml = params[:xml]
    hyperedition_type = params[:type]
    encoding = params[:encoding]
    encoding = "application/xml+#{encoding.downcase}"
    layer = params[:layer] || 0
    options = params[:options]
    version = params[:version]

    case hyperedition_type.downcase
    when 'text-reconstruction'
      edition = TaliaCore::TextReconstruction.new()
    when 'transcription'
      edition = TaliaCore::Transcription.new()
    end

    # the last parameter is set to true because this is a preview, it's needed
    # in some transformation, to pass a parameter to the XSLT
    @output = edition.to_html(version, layer, xml, encoding, true)
    render :layout => false
      #:inline => output
  end

end

