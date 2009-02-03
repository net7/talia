# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
module Globalize
  class Locale
    attr_accessor :magick
  end
end


class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem

  before_filter :prepare_locale, :check_i18n_cache
  before_filter :set_globalize

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

  private

  # Removes the globalize cache if applicable
  def check_i18n_cache
    magick_cache = session[:glob_cache]
    if(!magick_cache || (Globalize::Locale.active.magick != magick_cache))
      flush_locale(magick_cache)
    end
  end

  # Sets the local to the value from the session
  def prepare_locale
    locale = session[:locale] || "en-US"
    if(locale != Locale.active.code)
      # set the new locale
      Locale.set(locale)
      session[:locale] = Locale.active.code
      session[:__globalize_translations] = nil
      logger.debug("[#{Time.now.to_s(:db)}] - Set current Locale on #{Locale.language}")
    end
  end

  # Flush the locale cache and update the magick cookie. This will create a new
  # magick cookie if none is passed in
  def flush_locale(magick = nil)
    magick_val = magick || "#{rand 10E16}"
    Globalize::Locale.clear_cache
    Globalize::Locale.active.magick = magick_val
    session[:glob_cache] = magick_val unless(magick)
  end

  # Sets a controller variable to indicate that the globalization is active
  # (meaning that the current page allows transaltions). Used to provide a
  # shortcut since this is called often
  def set_globalize
    @globalize = globalize?
  end

  
end
