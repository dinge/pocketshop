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
      { :title      => node.title,
        :price      => node.price,
        :imagePath  => node.image_path }
    end
  end

end
