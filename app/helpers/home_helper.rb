module HomeHelper
  
  def select_language(name, locale)
    link_to(name, { :controller => 'languages', :action => 'change', :id => locale })
  end
  
  def render_home(options)
    render :partial => 'start_template', :locals => {
      :title_links => options[:title_links],
      :languages => options[:languages],
      :footer_link => options[:footer_link]
    }
  end
  
  # Puts a list of links to all editions of the given type
  def edition_links(type)
    render(:partial => 'edition', :collection => @editions[type]) if(@editions && @editions[type])
  end

  # Puts the editions of all the given types in one list, ordered by the editions
  # 'position' property.
  def sorted_editions(*types)
    return unless @editions
    all_editions = []
    types.each do |type|
      all_editions.concat(@editions[type]) if(@editions[type])
    end
    all_editions.sort! { |a,b| a.position.to_i <=> b.position.to_i }
    render(:partial => 'edition', :collection => all_editions)
  end
  
  # Puts the category links for the AvEdition
  def category_links
    render(:partial => 'category', :collection => @editions[:categories])
  end
  
  # Puts the series links for the AvEdition
  def series_links
    render(:partial => 'series', :collection => @editions[:series])
  end
  
  # The edition prefix for the given edition
  def prefix_for(edition)
    edition.class::EDITION_PREFIX
  end

  
end
