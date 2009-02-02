class AvMediaSourcesController < ApplicationController
  before_filter :normalize_uri, :only => :show

  def show
    # TODO theoretically the following statement isn't needed and also performs a useless db query,
    # because AR::Base#find raise a proper exception if something is missing.
    raise(ArgumentError, "Unknow Media Source #{params[:id]}") unless(TaliaCore::AvMedia.exists?(params[:id]))
    
    @element = TaliaCore::AvMedia.find(params[:id])
    cat = @element.category
    @path = [ { :text => t(:"talia.names.#{cat.class.name.underscore}.#{cat.name.underscore}"), :link => ("#{N::LOCAL}categories/" + cat.uri.local_name) }, { :text => @element.title } ]
    @title = t(:'talia.global.category') + " | #{cat.name}"
    @subtitle = t(:'talia.global.category')
  end
  
  private
    def normalize_uri
      params[:id] = CGI::unescape(params[:id]).gsub(' ', '+')
      params[:id] = N::LOCAL + 'av_media_sources/' + params[:id]
    end
end
