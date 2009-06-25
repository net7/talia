module CriticalEditionsHelper
  def print_title
    @book ? @book.title : edition_page_title
  end
  
  def custom_styles
    styles = ''
    if(@custom_edition_stylesheet)
      @custom_edition_stylesheet.each do |style|
        styles << stylesheet_link_tag(custom_style)
      end
    end
    
    styles
  end
end
