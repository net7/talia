# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Returns the title for the whole page. This returns the value
  # set in the controller, or a default value
  def page_title
    @page_title ? @page_title : "Talia | The Digital Library"
  end
  
  # Returns the subtitle for the page. See page_title
  def page_subtitle
    @page_subtitle ? @page_subtitle : "Let's discover what's out there"
  end
end
