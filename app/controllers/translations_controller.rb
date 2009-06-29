class TranslationsController < ApplicationController
  layout nil
  require_role 'admin'
  
  def edit
    I18n.locales.values
    @key = ViewTranslation.s_unencode(params[:id])
    @raw_key = params[:id]
    @translations = ViewTranslation.find_all_for(@key)
  end
  
  def update
    key = ViewTranslation.s_unencode(params[:id])
    # Loop through all languages and save
    I18n.locales.values.each do |code|
      next unless(params[code] && params[code] != '')
      ViewTranslation.create_or_update([{ 'id' =>  params["#{code}_id"], 'tr_key' => key, 'text' => params[code] }], code)
    end
    render(:update) do |page|
      page.call('Shadowbox.close')
      active = params[Locale.active.code]
      if(active)
        page.replace_html(params[:id], active)
        page.delay(1) do
          page.visual_effect('highlight', params[:id])
        end
      end
    end
  end
  
end
