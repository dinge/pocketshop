class Local::Users::SessionsController < ApplicationController
  skip_before_filter :redirect_to_login
  before_filter :redirect_to_root, :if => Proc.new{ Me.someone? }, :except => :destroy

  def new
    @local_user = Local::User.value_object.new
  end

  def create
    if @local_user = Local::User.by_credentials(params[:local_user][:name], params[:local_user][:password])
      start_local_session_with(@local_user)
      redirect_to root_path #@local_user.last_action || root_path 
    else
      @local_user = Local::User.value_object.new
      @local_user.name = params[:local_user][:name]
      stop_local_session
      render :action => "new"
    end
  end

  def destroy
    stop_local_session
    redirect_to root_path
  end



end
