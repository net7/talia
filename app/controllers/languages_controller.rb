class LanguagesController < ApplicationController
  layout nil
  before_filter :normalize_referer, :only => :change

  # GET /languages/en-US/change
  def change
    Locale.set(params[:id]) if params[:id]
    session[:locale] = Locale.active.code
    redirect_to :back
  end
  
  private
    def normalize_referer
      request.env["HTTP_REFERER"] ||= root_url
    end
end
