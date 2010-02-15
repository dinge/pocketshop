class ApplicationController < ActionController::Base
  layout nil
  helper :all

  include ControllerExtensions::AuthentificationHandling

  around_filter :init_neo4j_transaction
  before_filter :start_debugger     if Rails.env.development?
  around_filter :init_and_reset_me
  before_filter :redirect_to_login, :if => Proc.new{ Me.none? }
  before_filter :set_timezone

  filter_parameter_logging :password
  protect_from_forgery # :secret => 'ca7b3922b69a338bbbc85f5b3ee487cf'

  def start_debugger
    # debugger
    1==1
    1==1
  end

  def init_neo4j_transaction
    Neo4j::Transaction.run{ yield }
  end

  def set_timezone
    Time.zone = 'Berlin' # TODO: this will later be based on user setting or so
  end

  def redirect?
    response.status.to_i / 100 == 3
  end

end


# before_filter :setup_neodb

# def setup_neodb
#   @db_id = rand(2)
#   Neo4j::Config[:storage_path] = "tmp/neo4j_test/#{@db_id}"
#   Neo4j.stop
#   Neo4j.start
# end
