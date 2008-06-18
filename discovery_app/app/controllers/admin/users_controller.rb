class Admin::UsersController < ApplicationController
  require_role 'admin'
  PER_PAGE = 10

  def index
    @users = User.paginate(:page => params[:page], :per_page => PER_PAGE)
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      flash[:notice] = "User was successfully created."
      redirect_to :action => 'show', :id => @user
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(params[:user])
      flash[:notice] = "User was successfully updated."
      redirect_to :action => 'show', :id => @user
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    redirect_to :action => 'index'
  end
end
