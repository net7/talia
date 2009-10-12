module CriticalEditionsHelper
  def print_title
    @book ? @book.title : edition_page_title
  end
  
  def custom_styles
    styles = ''
    if(@custom_stylesheet)
      @custom_stylesheet.each do |custom_style|
        case custom_style
        when Array
          styles << stylesheet_link_tag(custom_style[0], :media => custom_style[1])
        when String
          styles << stylesheet_link_tag(custom_style, :media => "all")
        end
      end
    end
    
    styles
  end

  def advanced_search_result_description
    result = "<p class='advanced_search_result_description'>"
    # add count and work
    result += "<span class='red'>#{@result_match_count}</span> #{t(:'talia.search.result phrase 0')} " unless @result_match_count == "-1"
    result += "<span class='red'> #{@words}</span> #{t(:'talia.search.result phrase 1')} <span class='red'>#{@result_count}</span> #{t(:'talia.search.result phrase 2')}"
    # add subpart
    @searched_works.each do |item|
      unless item[:work].nil?
        result += "<br /> #{t(:'talia.search.result.optional.in the work')} <i>#{item[:work]}</i>, #{t(:'talia.search.result.optional.in aphorisms')} <i>#{item[:from]}</i> #{t(:'talia.search.result.optional.through')} <i>#{item[:to]}</i>"
      end
      unless item[:single_work].nil?
        result += "<br /> #{t('talia.search.result.optional.in the ' + item[:type])} <i>#{item[:single_work]}</i>"
      end

    end unless @searched_works.nil?


    result += "</p>"

    # return result
    return result
  end
end
