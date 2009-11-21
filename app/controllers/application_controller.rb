class ApplicationController < ActionController::Base
  before_filter :init_me
  before_filter :set_timezone
  before_filter :redirect_to_login, :if => Proc.new{ Me.none? }

  # after_filter :update_my_last_action, :if => Proc.new{ Me.someone? }
  after_filter :reset_me

  helper :form, :navigation, :quick_view, :tag, :things

  filter_parameter_logging :password
  protect_from_forgery # :secret => 'ca7b3922b69a338bbbc85f5b3ee487cf'


  def init_me
    reset_me
    if session[:user_id] && user = User.load(session[:user_id])
      user.is_me_now
    end
  end

  def reset_me
    Me.reset
  end

  def set_timezone
    Time.zone = 'Berlin' # TODO: this will later be based on user setting or so
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

  def redirect?
    response.status.to_i / 100 == 3
  end

  def redirect_to_root
    redirect_to root_path
  end


  def self.use_neo4j_transaction
    around_filter :init_neo4j_transaction
  end

  def init_neo4j_transaction
    ::Neo4j::Transaction.run{ yield }
  end

end


# before_filter :setup_neodb

# def setup_neodb
#   @db_id = rand(2)
#   Neo4j::Config[:storage_path] = "tmp/neo4j_test/#{@db_id}"
#   Neo4j.stop
#   Neo4j.start
# end
