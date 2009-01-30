class HomeController < ApplicationController
  
  # The types of edition that should be shown on the start page
  def self.editions_to_show 
    return @editions_to_show if(@editions_to_show)
    if(eds = TaliaCore::CONFIG['start_page_editions'])
      @editions_to_show = eds.collect { |v| v.to_sym }
    else
      @editions_to_show = [:facsimile, :critical, :categories, :series]
    end
    @editions_to_show
  end
  
  def start
    @editions = {}
    for edition in self.class.editions_to_show
      case edition
      when :categories
        @editions[:categories] = TaliaCore::Category.find(:all)
      when :series
        @editions[:series] = TaliaCore::Series.find(:all)
      else
        @editions[edition] = "TaliaCore::#{edition.to_s.camelize}Edition".constantize.find(:all)
      end
    end
    
    @page_title = t(:'talia.start_page.welcome_to') + " #{TaliaCore::SITE_NAME}"
  end
  
  def select_language
    if(allowed_locales.include?(params['id']))
      Locale.set(params['id'])
      redirect_to :action => 'start'
    end
  end

  # Create a locale-sensitve URL by replacing "LANG" in the current string with
  # the current language code
  def locale_uri(string)
    string.gsub(/LANG/, Locale.language_code)
  end

  private
  
  def allowed_locales
    I18n.locales.values
  end
  
end
