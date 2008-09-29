class LanguagesController < ApplicationController
  layout nil
  
  # GET /languages/en-US/change
  def change
    Locale.set(params[:id]) if params[:id]
    session[:locale] = Locale.active.code
    redirect_to :back
  end
end
