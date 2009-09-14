class Admin::CustomTemplatesController < ApplicationController
  layout 'admin'
  require_role 'admin'
  
  active_scaffold :custom_template do |config|
    config.columns = [:name, :template_type, :content]
    config.action_links.add 'clear_cache', :label => 'Clear Cache'
  end
  
  def clear_cache
    CustomTemplate.find(:all).each do |template|
      expire_page(:controller => '/custom_templates', :action => template.template_type, :id => template.name)
    end
    render :text => 'Template cache cleared'
  end
  
  protected 
  
  # Before an updated record, clean out the cache for that page
  def before_update_save(record)
    expire_page(:controller => '/custom_templates', :action => record.template_type, :id => record.name)
    puts "EXPIRED"
  end
  
end
