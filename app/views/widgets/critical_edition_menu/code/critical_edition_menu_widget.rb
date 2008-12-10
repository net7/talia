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

  # Renders the given item in it's own element, using the item partial
  def put_item(item, type = nil)
    select_class = ''
    select_class = ' class="selected" 'if(type && element_chosen?(type, item))
    partial('item', :locals => { :item_uri => item_uri_for(item), :item_title => title_for(item), :select_class => select_class })
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
