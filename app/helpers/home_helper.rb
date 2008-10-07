module HomeHelper
  
  def select_language(name, locale, accesskey)
    link_to(name, { :controller => 'locale', :action => 'set', :id => locale }, { :title => "#{name}, AccessKey: #{accesskey}", :accesskey => accesskey })
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
    render(:partial => 'edition', :collection => @editions[type]) if(@editions[type])
  end
  
  # Pust the category links for the AvEdition
  def av_category_links
    render(:partial => 'category', :collection => @editions[:av].first.elements(TaliaCore::Category))
  end
  
  # The edition prefix for the given edition
  def prefix_for(edition)
    edition.class::EDITION_PREFIX
  end
  
end
