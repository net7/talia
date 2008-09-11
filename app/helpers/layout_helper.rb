module LayoutHelper
  def title(page_title)
    @content_for_title = if page_title.to_s
    elsif @source
      short_name(@source)
    end
  end
end