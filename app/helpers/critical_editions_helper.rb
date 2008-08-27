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
    prefix = N::LOCAL.to_s + TaliaCore::CriticalEdition::EDITION_PREFIX
    path = []
    case action_name
    when "show"
      path = [{:text => params[:id]}]
    when "book"
      path = [
        {:text => params[:id], :link => prefix + "/#{params[:id]}"}, 
        {:text => @book.dcns.title.to_s}        
      ]
    when "chapter"
      path = [
        {:text => params[:id], :link => prefix + "/#{params[:id]}"}, 
        {:text => @book.dcns.title.to_s, :link => @book.uri.to_s},
        {:text => @chapter.dcns.title.to_s}
      ]
    when "part"
      path = [
        {:text => params[:id], :link => prefix + "/#{params[:id]}"}, 
        {:text => @book.dcns.title.to_s, :link => @book.uri.to_s}
      ]
        path << {:text => @chapter.dcns.title.to_s, :link => @chapter.uri.to_s} unless @chapter.nil?
        path << {:text => @part.dcns.title.empty? ? @part.uri.local_name.to_s : @part.dcns.title.to_s}
      
      end    
      path
    end
  end
