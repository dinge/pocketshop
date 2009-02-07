class Local::Users::SessionsController < ApplicationController

  skip_before_filter :init_me

  def index
    render :text => "harras"
  end

  def new
    @local_user ||= Local::User.value_object.new
  end

  def create
    if @local_user = Local::User.valid_login?(params[:local_user][:name], params[:local_user][:password])
      start_local_session_with(@local_user)
      redirect_to root_path
    else
      stop_local_session
      render :action => "new"
    end

  end

  def destroy
    stop_local_session
    redirect_to root_path
  end

end
