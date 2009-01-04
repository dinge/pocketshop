class IndexController < ApplicationController

  def index
    redirect_to concepts_path
  end
end
