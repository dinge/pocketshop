class ApplicationController < ActionController::Base
  helper :form, :navigation, :quick_view, :tag

  before_filter :init_me
  before_filter :update_current_users_last_action_at
  after_filter :reset_me

  # before_filter :setup_neodb


  def init_me
    Me.now = Sys::User.first  #Sys::User.load(4118)
  end

  def reset_me
    Me.now = nil
  end

  def update_current_users_last_action_at
    Me.now.last_action_at = DateTime.now
  end


  # def setup_neodb
  #   @db_id = rand(2)
  #   Neo4j::Config[:storage_path] = "tmp/neo4j_test/#{@db_id}"
  #   Neo4j.stop
  #   Neo4j.start
  # end


  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'ca7b3922b69a338bbbc85f5b3ee487cf'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password




end
