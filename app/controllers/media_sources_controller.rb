class MediaSourcesController < ApplicationController

  layout 'simple_page'
  
  def show
    element_uri = N::LOCAL + 'media_sources/' + params[:id]
    raise(ArgumentError, "Unknow Media Source #{element_uri}") unless(TaliaCore::Media.exists?(element_uri))
    
    @element = TaliaCore::Media.find(element_uri)
    cat = @element.category
    @path = [ { :text => t(:"talia.names.#{cat.class.name.underscore}.#{cat.name.underscore}"), :link => ('categories/' + cat.uri.local_name) }, { :text => @element.title } ]
    @title = t(:'talia.global.category') + " | #{cat.name}"
    @subtitle = t(:'talia.global.category')
  end
end
