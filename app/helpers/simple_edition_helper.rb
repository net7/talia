module SimpleEditionHelper
  
  # Insert the toolbar
  def toolbar(tools)
    render(:partial => 'shared/toolbar_item', :collection => tools)
  end
  
  def edition_partial(name)
    render(:partial => "#{@edition_type}_editions/#{name}")
  end
  
  def edition_page_title
    "#{TaliaCore::SITE_NAME} | #{@edition.title}#{@page_title_suff}"
  end

  def edition_include_name
    "editions/#{@edition_type}"
  end
  
  def edition_javascript_include
    javascript_include_tag edition_include_name
  end
  
  def edition_style_link
    links = ''
    links << stylesheet_link_tag(edition_include_name) 
    links << stylesheet_link_tag("editions/#{@edition.uri.local_name}")
    links
  end
  
end
