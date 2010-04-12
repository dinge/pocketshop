class Kos::PocketUi::ItemsController < ApplicationController
  around_filter :neo_transaction
  before_filter :init_resources

  def index
    respond_to do |format|
      format.json { render :json => @resources }
    end
  end


private

  def init_resources
    @resources = Kos::PocketStore::Item.all.nodes.map do |node|
      { :id         => node.props['_neo_id'],
        :title      => node.title,
        :price      => node.price,
        :image_path => node.image_path,
        :large_image_path => node.large_image_path }
    end
  end

end
