# TODO remove this file when update to Rails 2.3.x
class SprocketsController < ApplicationController
  caches_page :show
  
  def show
    render :text => SprocketsApplication.source, :content_type => "text/javascript"
  end
end
