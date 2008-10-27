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
  
  def edition_include_custom_name(custom)
    "editions/#{@edition_type}_custom/#{custom}"
  end
  
  def edition_javascript_include
    javascript_include_tag edition_include_name
  end
  
  def edition_style_link
    links = ''
    if @custom_stylesheet.nil?
      links << stylesheet_link_tag(edition_include_name)
      links << stylesheet_link_tag("editions/#{@edition.uri.local_name}")
      links << stylesheet_link_tag("editions/#{@edition.uri.local_name}", :media => 'print')
    else
      @custom_stylesheet.each do |custome_style|
        links << stylesheet_link_tag(edition_include_custom_name(custome_style))
        links << stylesheet_link_tag(edition_include_custom_name(custome_style), :media => 'print')
      end
    end
    
    links
  end
  
end
