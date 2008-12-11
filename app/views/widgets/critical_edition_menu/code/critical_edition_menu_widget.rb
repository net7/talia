class CriticalEditionMenuWidget < Widgeon::Widget

  def on_init
    @advanced_search = false if @advanced_search.nil?
  end

  # Returns the uri to use for the given element
  def item_uri_for(item)
    if(@advanced_search)
      item.elements['talia:uri'].text.strip
    else
      item.uri.to_s
    end
  end

  # Returns the title for the given element
  def title_for(item)
    if(@advanced_search)
      title = item.elements['talia:title'].text.strip
      if(title.empty?)
        uri = item.elements['talia:uri'].text.strip
        title = uri.split('/')[-1]
      end
      title
    else
      item.dcns::title.first.to_s
    end
  end

  # Renders the given chapter in it's own element.
  def put_chapter(chapter)
    select_class = ''
    if(element_chosen?(:chapter, chapter))
      # Set the class depending on if there's a selected sub-part
      select_class = @chosen_part ?'class="opened"' : 'class="selected"'
    end
    partial('item', :locals => { :item_uri => item_uri_for(chapter), :item_title => title_for(chapter), :select_class => select_class })
  end

  # Renders the given book in it's own element.
  def put_book(book)
    select_class = ''
    if(element_chosen?(:book, book))
      # Set the class depending on if there's a selected sub-part
      select_class = @chosen_chapter ? 'class="opened"' : 'class="selected"'
    end
    partial('item', :locals => { :item_uri => item_uri_for(book), :item_title => title_for(book), :select_class => select_class })
  end

  # Renders the given part in it's own element
  def put_part(part)
    select_class = element_chosen(:part, part) ? 'class="selected"' : ''
    partial('item', :locals => { :item_uri => item_uri_for(part), :item_title => title_for(part), :select_class => select_class })
  end

  # Returns true if the given element is the chosen element of the given type
  # (:book or :chapter). "Chosen" means that the element is currently selected.
  def element_chosen?(type, element)
    chosen_el = self.instance_variable_get(:"@chosen_#{type}")
    chosen_el && (chosen_el.uri.to_s == item_uri_for(element))
  end

  # Renders the second level of the menu for the given book. This choses whether
  # it needs to render a list of chapters, or rather a list of parts.
  def show_second_level_for(book)
    chapters = @advanced_search ? book.get_elements('talia:group') : book.chapters
    if(!chapters.empty?)
      partial('chapters', :object => chapters)
    else
      parts = book.subparts_with_manifestations(N::HYPER.HyperEdition)
      partial('parts', :object => parts)
    end
  end

  # Gets the parts for this chapter
  def parts_for(chapter)
    if(@advanced_search)
      chapter.get_elements('talia:group')
    else
      chapter.subparts_with_manifestations(N::HYPER.HyperEdition)
    end
  end

end
