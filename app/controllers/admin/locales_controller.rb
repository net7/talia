class Admin::LocalesController < ApplicationController
  def new
  end

  def create
    if I18n.add_locale(params[:name], params[:code])
      redirect_to edit_admin_translation_path(params[:code])
    else
      flash[:error] = "Invalid locale, please check the format and make sure the language is available."
      render :action => 'new'
    end
  end
end
