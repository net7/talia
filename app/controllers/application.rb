# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem

  helper :all # include all helpers, all the time

  # Require some model classes that should always be present
  %w( source expression_card catalog facsimile_edition critical_edition manifestation book page paragraph note chapter facsimile text_reconstruction transcription av_media ).each do |klass|
    require_dependency "talia_core/#{klass}"
  end
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery :secret => '55167f74a02e580cb66ed22f880ed014'

  # Delegate to I18n instead of hardcode locales there, because application.rb
  # is evauated *one* time in production.
  self.languages = I18n.locales

  # Override to allow the translations only to the translators
  def globalize?
    !%w( widgeon ).include?(self.controller_name) && logged_in? &&
      current_user.authorized_as?('translator')
  end
  
  # Translate the symbol
  def t(symbol)
    symbol.to_s.t
  end
  
end
