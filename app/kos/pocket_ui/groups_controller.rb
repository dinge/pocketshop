class Kos::PocketUi::GroupsController < ApplicationController
  around_filter :neo_transaction
  before_filter :init_resources

  def index
    respond_to do |format|
      format.json { render :json => @resources }
    end
  end


private

  def init_resources
    @resources = Kos::PocketStore::Group.pub.map do |node|
      {
        :id           => node.props['_neo_id'],
        :title        => node.title,
        :image_path   => node.image_path,
        :item_ids     => node.items.map { |i| i.props['_neo_id'] }
       }
    end
  end


end
