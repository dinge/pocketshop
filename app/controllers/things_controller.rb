class ThingsController < ApplicationController
  uses_rest
  uses_acl

  private

  # use_acl do
  #   visible_for :creator, :groups
  #   createable_for :owner
  #   destroyable_for :owner
  #   changeable_for :owner
  # end

end
