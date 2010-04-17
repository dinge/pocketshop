class ApplicationController < ActionController::Base
  protect_from_forgery

  around_filter :neo_transaction
  before_filter :init_store


  def neo_transaction
    Neo4j::Transaction.run do
      yield
    end
  end


  def init_store
    @current_store = if params[:store_ident]
      Kos::PocketStore.store_by_ident(params[:store_ident])
    else
      Kos::PocketStore::Store.all.nodes.to_a.rand
    end
  end

end
