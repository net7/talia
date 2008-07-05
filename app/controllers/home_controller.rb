class HomeController < ApplicationController
   include TaliaCore
   
  def start
    @facsimile_editions = RdfQuery.new(:EXPRESSION, N::HYPER::macrocontributionType, "Facsimile").execute
    
    @critical_editions = RdfQuery.new(:EXPRESSION, N::HYPER::macrocontributionType, "Critical").execute
    
    @page_title = "Welcome to #{TaliaCore::SITE_NAME}".t
  end

end
