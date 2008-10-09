module MediaSourcesHelper
  
  def video_box
    if(params[:format] == 'mp4')
      render(:partial => 'mp4_movie')
    else
      render(:partial => 'wmv_movie')
    end
  end
  
end
