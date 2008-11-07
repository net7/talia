class AvMediaSourcesController < ApplicationController
  
  def show
    element_uri = N::LOCAL + 'av_media_sources/' + params[:id]
    raise(ArgumentError, "Unknow Media Source #{element_uri}") unless(TaliaCore::AvMedia.exists?(element_uri))
    
    @element = TaliaCore::AvMedia.find(element_uri)
    cat = @element.category
    @path = [ { :text => t(:"talia.names.#{cat.class.name.underscore}.#{cat.name.underscore}"), :link => ("#{N::LOCAL}categories/" + cat.uri.local_name) }, { :text => @element.title } ]
    @title = t(:'talia.global.category') + " | #{cat.name}"
    @subtitle = t(:'talia.global.category')
  end
end
