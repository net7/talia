class HomeController < ApplicationController
  def start
    @page_title = "Welcome to #{TaliaCore::SITE_NAME}".t
  end

end
