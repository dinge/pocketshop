class ThingsController < ApplicationController
  use_rest

  private

  # before_filter :init_thing, :only => [:show, :edit, :update, :destroy]

  # before_filter :creatable?, :only => [:new, :create]
  # before_filter :visible?, :only => :show
  # before_filter :changeable?, :only => [:edit, :update]
  # before_filter :destroyable?, :only => :destroy

  # use_acl do
  #   visible_for :creator, :groups
  #   createable_for :owner
  #   destroyable_for :owner
  #   changeable_for :owner
  # end


  def creatable?
    unless Thing.creatable_for?(Me.now)
      flash[:error] = "access forbidden"
      redirect_to root_path
    end
  end

  def visible?
    unless @thing.visible_for?(Me.now)
      flash[:error] = "access forbidden"
      redirect_to root_path
    end
  end

  def changeable?
    unless @thing.changeable_for?(Me.now)
      flash[:error] = "access forbidden"
      redirect_to root_path
    end
  end

  def destroyable?
    unless @thing.destroyable_for?(Me.now)
      flash[:error] = "access forbidden"
      redirect_to root_path
    end
  end

end
