class Admin::TranslationsController < ApplicationController
  layout 'admin'
  require_role 'admin'
  PER_PAGE = 30

  after_filter :flush_locale, :only => [:update, :destroy]

  # GET /admin/translations
  def index
    redirect_to edit_admin_translation_path(Locale.active.code)
  end

  # GET /admin/translations/search?key1=hello%20world&key2=good_morning
  def search
    keys = params.map {|key, value| value if key.to_s =~ /key/}.compact
    translations = ViewTranslation.find_by_locale_and_tr_key(params[:locale], keys)
    session[:reference_locale] = params[:locale]

    respond_to do |format|
      format.js { render :layout => false, :inline => translations.to_json }
    end
  end

  # GET /admin/translations/en-US/edit
  def edit
    @translations = ViewTranslation.find_by_locale(params[:id], :order => "tr_key ASC")
    @locale_code = params[:id]
    @autoload = load_reference_translations?
  end

  # PUT /admin/translations/en-US
  def update
    if ViewTranslation.create_or_update(params[:translations], params[:id])
      flash[:notice] = 'Your translations has been saved'
    else
      flash[:error]  = 'There was some problems'
    end

    redirect_to edit_admin_translation_path(params[:id])
  end

  # DELETE /admin/translations/1
  def destroy
    @translation = ViewTranslation.find(params[:id])
    @translation.destroy

    respond_to do |format|
      format.html do
        flash[:notice] = 'Your translation has been deleted'
        redirect_to edit_admin_translation_path(params[:locale])
      end
      format.js
    end
  end

  private

  def load_reference_translations?
    !!session[:reference_locale] && session[:reference_locale] != params[:locale]
  end
end