class HomeController < ApplicationController
     
  def start

    @facsimile_editions = TaliaCore::FacsimileEdition.find(:all)
    @critical_editions = TaliaCore::CriticalEdition.find(:all)
    
    @page_title = "Welcome to #{TaliaCore::SITE_NAME}".t
  end
  
  def select_language
    if(allowed_locales.include?(params['id']))
      Locale.set(params['id'])
      redirect_to :action => 'start'
    end
  end

  private
  
  def allowed_locales
    %w(en-US de-DE fr-FR it-IT)
  end
  
end
