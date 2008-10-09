class HomeController < ApplicationController
  
  # The types of edition that should be shown on the start page
  def self.editions_to_show 
    return @editions_to_show if(@editions_to_show)
    if(eds = TaliaCore::CONFIG['start_page_editions'])
      @editions_to_show = eds.collect { |v| v.to_sym }
    else
      @editions_to_show = [:facsimile, :critical, :categories]
    end
    @editions_to_show
  end
  
  def start
    @editions = {}
    for edition in self.class.editions_to_show
      if(edition == :categories)
        @editions[:categories] = TaliaCore::Category.find(:all)
      else
        @editions[edition] = "TaliaCore::#{edition.to_s.camelize}Edition".constantize.find(:all)
      end
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
