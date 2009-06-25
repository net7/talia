module CriticalEditionsHelper
  def print_title
    @book ? @book.title : edition_page_title
  end
end
