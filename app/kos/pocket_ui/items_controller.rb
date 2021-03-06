class Kos::PocketUi::ItemsController < ApplicationController
  before_filter :init_resources

  def index
    respond_to do |format|
      format.json { render :json => @resources.to_public_pocket_ui }
    end
  end


private

  def init_resources
    @resources = Kos::PocketStore.public_items_by_store(@current_store)
  end

end
