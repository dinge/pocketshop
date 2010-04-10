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
    @resources = Kos::BattlemerchantCao::Category.all.nodes.map do |node|
      { :title      => node[:name],
        :id         => node[:id],
        :parent_id  => node[:top_id],
        :imagePath  => 'http://www.battlemerchant.com/images/product_images/original_images/%s' % node.image_file_name }
    end
  end


end
