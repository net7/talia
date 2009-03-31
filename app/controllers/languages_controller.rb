class LanguagesController < ApplicationController
  layout nil
  before_filter :normalize_http_referer, :only => :change

  # GET /languages/en-US/change
  def change
    I18n.locale = params[:id]
    session[:locale] = I18n.locale
    redirect_to :back
  end
  
  private
    def normalize_http_referer
      request.env["HTTP_REFERER"] ||= root_url
    end
end
