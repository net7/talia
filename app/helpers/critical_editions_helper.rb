module CriticalEditionsHelper
  def print_title
    @book ? @book.title : edition_page_title
  end
  
  def custom_styles
    styles = ''
    if(@custom_stylesheet)
      @custom_stylesheet.each do |custom_style|
        styles << stylesheet_link_tag(custom_style)
      end
    end
    
    styles
  end

  def advanced_search_result_description
    # add count and work
    result = "<h2> #{@result_count} #{t(:'talia.search.result phrase 1')} <span class='red'> #{@words} </span>"
    # add subpart
    @searched_works.collect do |item|
        result += " #{t(:'talia.search.result.optional.in the work')} '#{item[:work]}' #{t(:'talia.search.result.optional.in aphorisms')} #{item[:from]} #{t(:'talia.search.result.optional.through')} #{item[:to]},"
      end unless @searched_works.nil?

    # add edition title
    result += "#{t(:'talia.search.result phrase 2')} #{@edition.hyper::title}</h2> "

    # return result
    return result
    end
  end
