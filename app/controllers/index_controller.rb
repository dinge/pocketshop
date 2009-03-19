class IndexController < ApplicationController
  def index
    redirect_to things_path
  end
end
