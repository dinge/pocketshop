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
    @resources = Kos::BattlemerchantCao::Product.all.nodes.map do |node|
      { :title      => node[:kurzname],
        :id         => node[:_neo_id],
        :price      => node[:vk5b],
        :imagePath  => 'http://www.battlemerchant.com/images/product_images/thumbnail_images/%s.jpg' % node[:artnum] }
    end
  end

# info_images
# original_images
# thumbnail_images
# popup_images

end
