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
  # self.languages = I18n.locales

  # Override to allow the translations only to the translators
  def globalize?
    !%w( widgeon ).include?(self.controller_name) && logged_in? &&
      current_user.authorized_as?('translator')
  end
  
  # Translate the symbol
  def t(symbol)
    symbol.to_s.t
  end

  # Define if the caching must be performed
  # e.g. we don't need to use cache when we're logged in as a translator
  #
  # TODO: WARNING! this is a workaround for Rails 2.0, if/when Rails 2.1 or better
  # is used, we can move to adding the :if parameter to the caches_action statements
  def perform_caching
    @@perform_caching && !logged_in?
  end

  protected
    def local_request?
      false
    end

    def rescue_action_in_public(exception)
      case exception
      when ActiveRecord::RecordNotFound
        render :file => "#{RAILS_ROOT}/public/404.html", :status => :not_found
      else
        super
      end
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
    Locale.set(Locale.base_language.code) unless(Locale.active)
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

  # Action caching callback.
  # It's responsible to return the locale for the current request.
  #
  # Example:
  #   class ArticlesController < ApplicationController
  #     caches_action :show, :locale => :current_locale
  #
  #     def show
  #       @article = Article.find(params[:id])
  #     end
  #
  #     private
  #       def current_locale
  #         # ...
  #       end
  #   end
  #
  #   If no locale is set for the current request it will cache with default locale:
  #     [GET] /articles/1 # => http://example.com/articles/1?locale=en-US
  #
  #   Otherwise:
  #     [GET] /articles/1 # => http://example.com/articles/1?locale=it-IT
  def current_locale
    session[:locale] ||= Locale.base_language.code
  end
end
