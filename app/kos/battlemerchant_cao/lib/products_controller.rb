class Kos::BattlemerchantCao::ProductsController < ApplicationController

  around_filter :neo_transaction
  before_filter :init_nodes,  :only => :index
  before_filter :init_node,   :only => [:show, :edit, :destroy]

  respond_to :json

  def index
    respond_with(@nodes)
  end

  def show
    respond_with(@node)
  end


private

  def neo_transaction
    @_neo_transaction = Neo4j::Transaction.new
    yield
    @_neo_transaction.finish
  end

  def init_nodes
    @nodes = Kos::BattlemerchantCao::Product.all.nodes.to_json(:only => [:kurzname, :artnum, :vk5b, :rec_id])
  end

  def init_node
    @node = Neo4j.load(params[:id])
  end

end