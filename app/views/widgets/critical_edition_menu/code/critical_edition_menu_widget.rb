class CriticalEditionMenuWidget < Widgeon::Widget
  
  def menu
    @out =  "<ul class='toplevel book'>"
    @books.each do |book|
      @out << "<li><a href='#{book.uri.to_s}'>#{book.dcns.title}</a></li>"
      if @chosen_book == book
        @out << "<ul class='secondlevel pages'>"
        if !book.chapters.empty? 
          book.chapters.each do |chapter| 
            @out << "<li><a href='#{chapter.uri.to_s}'>#{chapter.dcns.title}</a></li>"
            if @chosen_chapter == chapter 
              @out << "<ul class='thirdlevel page'>"
              chapter.subparts_with_manifestation(N::TALIA.HyperEdition).each do |part|
                @out << "<li><a href='#{part.uri.to_s}'>#{part.dcns.title}</a></li>"
              end
              @out << '</ul>'
            end
          end
          @out << '</ul>'
        else
          unless book.parts.emtpy? 
            book.subparts_with_manifestations(N::TALIA.HyperEdition).each do |part|
              @out << "<ul class='thirdlevel page'>"
              @out << "<li><a href='#{part.uri.to_s}'>#{part.dcns.title}</a></li>"
              @out << '</ul>'
            end 
          end 
        end
      end
    end
    @out << '</ul>'
  end
  
end