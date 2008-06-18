module HomeHelper
  def titled_link (url, text)
    text = text.t
    "<a href='#{url}' title='#{text}'>#{text}</a>" 
  end
end
