class ApplicationController < ActionController::Base
  helper :form, :navigation, :quick_view, :tag

  before_filter :init_me
  before_filter :update_current_users_last_action
  after_filter :reset_me

  # before_filter :setup_neodb


  def init_me
    Me.now = Local::User.first_node || Local::User.new(:name => 'lars')
  end

  def reset_me
    Me.reset
  end

  def update_current_users_last_action
    Me.now.update!(:last_action => params, :last_action_at => DateTime.now)
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
