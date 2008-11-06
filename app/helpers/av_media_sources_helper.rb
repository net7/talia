module AvMediaSourcesHelper
  
  def video_box
    if(params[:media_type] == 'mp4')
      render(:partial => 'mp4_movie')
    else
      render(:partial => 'wmv_movie')
    end
  end
  
  def video_thumb(media_element)
    thumb = media_element.media(:image_data).first
    return "No Image for #{media_element.uri.to_name_s}" unless(thumb)
    talia_image_tag(thumb, :alt => 'thumbnail', :title => 'thumbnail')
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
