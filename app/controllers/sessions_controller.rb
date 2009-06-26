# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  cache_sweeper :editions_sweeper, :only => [:destroy]
  layout 'admin'

  # render new.rhtml
  def new
  end

  # login
  def create
    if using_open_id?
      open_id_authentication(params[:openid_url])
    else
      password_authentication(params[:login], params[:password])
    end
  end

  # logout
  def destroy
    if logged_in?
      self.current_user.forget_me
      empty_cache = true
    end
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    # When a translator logs out, we want to perform a cache cleaning, since we don't
    # know what that translator changed and where.
    # Still, we don't want to perform the cache cleaning any time a user invokes the
    # /logout URL 
    # To check if we are _actually_ performing a logout, we check if we were logged_in?
    #
    # TODO: why are we still logged in here? 
    if empty_cache
      # TODO: since we are still logged in here (why?), we need to empty the @current_user val
      # otherwise the perform_caching method (in the application controller) will return false
      # (as it esplicitely shuts down the caching when a user is logged in)
      @current_user = nil
      EditionsSweeper.instance.clean_cache
    end
    redirect_back_or_default('/')
  end
  
  protected
  
  # password authentication
  def password_authentication(login, password)
    self.current_user = User.authenticate(login, password)
    if logged_in?
      successful_login
    else
      failed_login
    end
  end
  
  # open id authentication
  def open_id_authentication(identity_url)
    authenticate_with_open_id(identity_url) do |status, identity_url|
      if status.successful?
        if self.current_user = User.open_id_authentication(identity_url)
          successful_login
        else
          failed_login "Sorry, no user by that identity URL exists (#{identity_url})"
        end
      else
        failed_login status.message
      end
    end
  end
  
  private
  
  # login successful
  def successful_login
    if params[:remember_me] == "1"
      self.current_user.remember_me
      cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
    end
    redirect_back_or_default('/')
    flash[:notice] = "Logged in successfully"
  end

  # login failed
  def failed_login(message = nil)
    flash[:error] = message if !message.nil?
    render :action => 'new'
  end
end
