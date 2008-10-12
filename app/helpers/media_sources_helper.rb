module MediaSourcesHelper
  
  def video_box
    if(params[:media_type] == 'mp4')
      render(:partial => 'mp4_movie')
    else
      render(:partial => 'wmv_movie')
    end
  end
  
  def excerpt(text)
    return '' unless(text)
    if(text.size > 50)
      text[0..50] + '...'
    else
      text
    end
  end
  
end
