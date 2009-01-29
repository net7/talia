class LanguagesController < ApplicationController
  layout nil
  before_filter :normalize_http_referer, :only => :change

  # GET /languages/en-US/change
  def change
    Locale.set(params[:id]) if params[:id]
    session[:locale] = Locale.active.code
    redirect_to :back
  end
  
  private
    def normalize_http_referer
      request.env["HTTP_REFERER"] ||= root_url
    end
end
