class AvMediaSourcesController < ApplicationController
  before_filter :normalize_uri, :only => :show
  caches_action :show, :locale => :current_locale
  
  def show
    @element = TaliaCore::AvMedia.find(params[:id])
    cat = @element.category
    @path = [ { :text => t(:"talia.names.#{cat.class.name.underscore}.#{cat.name.underscore}"), :link => ("#{N::LOCAL}categories/" + cat.uri.local_name) }, { :text => @element.title } ]
    @title = t(:'talia.global.category') + " | #{cat.name}"
    @subtitle = t(:'talia.global.category')
  end
  
  private
    def normalize_uri
      params[:id] = UriEncoder.unescape_link(params[:id])
      params[:id] = N::LOCAL + 'av_media_sources/' + params[:id]
    end
end
