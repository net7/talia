class SeriesController < ApplicationController

  layout 'simple_page'
  
  def show
    element_uri = N::LOCAL + 'series/' + params[:id]
    raise(ArgumentError, "Unknow Series #{element_uri}") unless(TaliaCore::Series.exists?(element_uri))
    
    @element = TaliaCore::Series.find(element_uri)
    @path = [ { :text => 'Series', :link => 'series/' }, { :text => @element.hyper::name.first } ]
    @title = t(:'talia.global.series') + " | #{@element.hyper::name.first }"
    @subtitle = t(:'talia.global.series')
  end

  def index
    @path = [ { :text => 'Series' }]
    @series = TaliaCore::Series.find(:all)
    @title = t(:'talia.global.series')
    @subtitle = t(:'talia.global.series')
  end
end
