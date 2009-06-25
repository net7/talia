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
end
