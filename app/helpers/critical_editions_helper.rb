module CriticalEditionsHelper
  # creates the window title 
  def critical_edition_page_title
    case action_name
    when "show"
      "#{TaliaCore::SITE_NAME} | #{@critical_edition.hyper::title}"
    end
  end
  
  # creates the elements to be shown in the path
  def critical_edition_path 
    path = []
    case action_name      
    when "show"
      path = [{:text => params[:id]}]
    when "dispatcher"
      # The dispatcher case deals with every case other than the first page
      # We need to understand what the requested source is to be able to construct 
      # the right path
      case @source #defined in the critical_edition_controller
      when TaliaCore::Book
        path = [
          {:text => params[:id], :link => @critical_edition.uri.to_s}, 
          {:text => @book.dcns.title[0].to_s}        
        ]
      when TaliaCore::Chapter
        path = [
          {:text => params[:id], :link => @critical_edition.uri.to_s}, 
          {:text => @book.dcns.title[0].to_s, :link => @book.uri.to_s},
          {:text => @chapter.dcns.title[0].to_s}
        ]
      when TaliaCore::Page, TaliaCore::Paragraph
        path = [
          {:text => params[:id], :link => @critical_edition.uri.to_s}, 
          {:text => @book.dcns.title[0].to_s, :link => @book.uri.to_s}
        ]
        path << {:text => @chapter.dcns.title[0].to_s, :link => @chapter.uri.to_s} unless @chapter.nil?
        path << {:text => @part.dcns.title.empty? ? @part.uri.local_name.to_s : @part.dcns.title[0].to_s}
      end    
    end
    path
  end
end
