class HomeController < ApplicationController
  
  # The types of edition that should be shown on the start page
  @@editions_show = [:facsimile, :critical, :av]
  
  def start
    @editions = {}
    for edition in @@editions_show
      @editions[edition] = "TaliaCore::#{edition.to_s.camelize}Edition".constantize.find(:all)
    end
    
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
