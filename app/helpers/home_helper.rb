module HomeHelper
  
  def select_language(name, locale, accesskey)
    link_to(name, { :action => 'select_language', :id => locale }, { :title => "#{name}, AccessKey: #{accesskey}", :accesskey => accesskey })
  end
  
end
