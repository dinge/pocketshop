class IndexController < ApplicationController
  def index
    redirect_to tools_phrase_maker_triples_path
  end
end
