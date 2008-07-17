class HomeController < ApplicationController
   
  def start

    @facsimile_editions = TaliaCore::FacsimileEdition.find(:all)
    @critical_editions = TaliaCore::CriticalEdition.find(:all)
    
    @page_title = "Welcome to #{TaliaCore::SITE_NAME}".t
  end

end
