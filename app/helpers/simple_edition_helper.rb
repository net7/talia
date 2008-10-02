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
    js_path = File.join(RAILS_ROOT, 'public', 'javascripts', edition_include_name + '.js')
    javascript_include_tag edition_include_name if(File.exists?(js_path))
  end
  
  def edition_style_link
    links = ''
    style_path = File.join(RAILS_ROOT, 'public', 'stylesheets', edition_include_name + '.css')
    (links << stylesheet_link_tag(edition_include_name)) if(File.exists?(style_path))
    edition_style_path = File.join(RAILS_ROOT, 'public', 'stylesheets', 'editions', @edition.uri.local_name)
    (links << stylesheet_link_tag("editions/#{@edition.uri.local_name}")) if(File.exists?(edition_style_path))
    links
  end
  
end
