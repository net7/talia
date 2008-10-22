# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
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
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to login_path
  end
  
  protected
  
  # password authentication
  def password_authentication(login, password)
    self.current_user = User.authenticate(login, password)
    if logged_in?
      successful_login
    else
      message = "Sorry, could not log you in. Please check your username and password" if request.post?
      failed_login message
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
    redirect_to admin_path
  end

  # login failed
  def failed_login(message = nil)
    flash.now[:error] = message if !message.nil?
    render :action => 'new'
  end
end
