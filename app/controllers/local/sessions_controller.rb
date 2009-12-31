class Local::SessionsController < ApplicationController
  skip_before_filter :redirect_to_login
  before_filter :redirect_to_root, :if => Proc.new{ Me.someone? }, :except => :destroy

  def new
    @user = User.value_object.new
  end

  def create
    if @user = User.by_credentials(params[:user][:name], params[:user][:password])
      start_local_session_with(@user)
      redirect_to root_path #@user.last_action || root_path
    else
      @user = User.value_object.new
      @user.name = params[:user][:name]
      stop_local_session
      render :action => "new"
    end
  end

  def destroy
    stop_local_session
    redirect_to root_path
  end

end