class CustomTemplatesController < ApplicationController
  
  layout nil
  session :off
  
  caches_page :xslt
  
  def stylesheets
    render_template('css', 'text/css')
  end
  
  def xslt
    render_template('xslt', 'application/xml')
  end
  
  private
  
  def render_template(type, mime_type)
    template = CustomTemplate.find(:first, :conditions => { :name => params[:id], :template_type => type })
    if(template)
      render(:text => template.content, :content_type => mime_type)
    else
      render(:nothing => true, :status => 404)
    end
  end
  
end
