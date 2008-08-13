module CriticalEditionsHelper
  # creates the window title 
  def critical_edition_page_title
    case action_name
    when "show"
#      "#{TaliaCore::SITE_NAME} | #{@critical_edition.hyper::title}"
    end
  end
  
  # creates the elements to be shown in the path
  def critical_edition_path 
    path = []
    case action_name
    when "show"
      path = [{:text => params[:id]}]
    else 
      path = [{:text => ''}]
    end
    path
  end
end
