class ApplicationController < ActionController::Base
  protect_from_forgery

  def neo_transaction
    @_neo_transaction = Neo4j::Transaction.new
    yield
    @_neo_transaction.finish
  end

end
