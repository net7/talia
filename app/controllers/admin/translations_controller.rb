class Admin::TranslationsController < ApplicationController
  layout 'admin'
  require_role 'admin'
  PER_PAGE = 30

  # GET /admin/translations
  def index
    redirect_to edit_admin_translation_path(Locale.active.code)
  end

  # GET /admin/translations/search?key1=hello%20world&key2=good_morning
  def search
    keys = params.map {|key, value| value if key.to_s =~ /key/}.compact
    translations = ViewTranslation.find_by_locale_and_tr_key(params[:locale], keys)
    
    respond_to do |format|
      format.js { render :layout => false, :inline => translations.to_json }
    end
  end

  # GET /admin/translations/edit/en-US
  def edit
    @translations = ViewTranslation.find_by_locale(params[:id], params[:page], PER_PAGE)
    @locale_code = params[:id]
  end

  # PUT /admin/translations/update/en-US
  def update
    if ViewTranslation.create_or_update(params[:translations], params[:id])
      flash[:notice] = 'Your translations has been saved'
    else
      flash[:error]  = 'There was some problems'
    end

    redirect_to edit_admin_translation_path(params[:id], {:page => params[:page]})
  end

  # DELETE /admin/translations/1
  def destroy
    @translation = ViewTranslation.find(params[:id])
    @translation.destroy
    
    respond_to do |format|
      format.html do
        flash[:notice] = 'Your translation has been deleted'
        redirect_to edit_admin_translation_path(params[:locale], {:page => params[:page]})
      end
      format.js
    end
  end
end