class ApplicationController < ActionController::Base
  helper :form, :navigation, :quick_view, :tag

  before_filter :init_me
  before_filter :update_current_users_last_action, :if => Proc.new{ Me.someone? }
  after_filter :reset_me

  # before_filter :setup_neodb

  def init_me
    reset_me
    if session[:local_user_id] && local_user = Local::User.load(session[:local_user_id])
      local_user.is_me_now
    else
      redirect_to login_path
    end
  end

  def reset_me
    Me.reset
  end

  def update_current_users_last_action
    Me.now.update!(:last_action => params, :last_action_at => DateTime.now)
  end




  def start_local_session_with(local_user)
    local_user.is_me_now
    session[:local_user_id] = local_user.id
  end
  
  def stop_local_session
    reset_me
    session[:local_user_id] = nil
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
