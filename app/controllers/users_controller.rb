class UsersController < ApplicationController
  def index
    render :index
  end
  
  def new
    @user = User.new
    render :new
  end
  
  def edit
    @user = User.find_by(id: params[:id])
    if @user 
      render :edit
    else
      redirect_to users_url
    end
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:session_token] = @user.reset_session_token!
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end
  
  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :edit
    end  
  end
  
  def show
    @user = User.find_by(id: params[:id])
    if @user 
      render :show
    else
      redirect_to users_url
    end
  end
  
  def destroy
    @user = User.find_by(id: params[:id])
    if @user.destroy
      flash[:notice] = ['USER DESTROYED!!! AHHH']
      redirect_to users_url
    elsif @user.nil?
      flash[:errors] = ["User doesn't exist"]
      redirect_to users_url
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to user_url(@user)
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
