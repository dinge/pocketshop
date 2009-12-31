module ControllerExtensions::AuthentificationHandling

  # before_filter :init_me
  # after_filter :reset_me
  # after_filter :update_my_last_action, :if => Proc.new{ Me.someone? }

  def init_and_reset_me
    reset_me
    init_me
    yield
    reset_me
  end

  def init_me
    if session[:user_id] && user = User.load(session[:user_id])
      user.is_me_now
    end
  end

  def reset_me
    Me.reset
  end

  def redirect_to_login
    redirect_to login_path
  end

  def start_local_session_with(user)
    user.is_me_now
    session[:user_id] = user.id
  end

  def stop_local_session
    reset_me
    session[:user_id] = nil
  end

  def update_my_last_action
    Me.update_last_action(request) if update_last_action?
  end

  def update_last_action?
    request.get? && !redirect? && !request.head?
  end

end