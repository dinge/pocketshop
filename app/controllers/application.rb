class ApplicationController < ActionController::Base
  helper :form, :navigation, :quick_view, :tag

  before_filter :init_me
  before_filter :redirect_to_login, :if => Proc.new{ Me.none? }

  after_filter :update_my_last_action, :if => Proc.new{ Me.someone? }
  after_filter :reset_me

  # before_filter :setup_neodb

  def init_me
    reset_me
    if session[:local_user_id] && local_user = Local::User.load(session[:local_user_id])
      local_user.is_me_now
    end
  end

  def reset_me
    Me.reset
  end

  def redirect_to_login
    redirect_to login_path
  end

  def start_local_session_with(local_user)
    local_user.is_me_now
    session[:local_user_id] = local_user.id
  end

  def stop_local_session
    reset_me
    session[:local_user_id] = nil
  end


  def update_my_last_action
    if request.get? && !redirect? && !request.head?
      Me.update_last_action(request)
    end
  end

  def redirect?
    response.status.to_i / 100 == 3
  end

  def redirect_to_root
    redirect_to root_path
  end

  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'ca7b3922b69a338bbbc85f5b3ee487cf'

  filter_parameter_logging :password

end



# def setup_neodb
#   @db_id = rand(2)
#   Neo4j::Config[:storage_path] = "tmp/neo4j_test/#{@db_id}"
#   Neo4j.stop
#   Neo4j.start
# end
