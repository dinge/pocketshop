class Tools::PhraseMaker::PhrasesController < ApplicationController

  before_filter :init_phrase, :only => [:phrase_merger, :json_for_path_based_graph, :json_for_grammar_based_graph]

  uses_page do
    assets do
      additional_javascripts [
        'vendor/jit-yc',
        'visualization/rgraph_setups',
        'tools/phrase_maker/phrase_maker',
        'tools/phrase_maker/phrase_graph'
      ]
      additional_stylesheets 'tools/phrase_maker/phrase_maker'
    end
  end

  uses_rest do
    model.klass Tools::PhraseMaker::Phrase
    respond_to.js true
  end



  def autocomplete
    render_widget autocompleter_widget
  end

  def phrase_merger
    respond_to { |wants| wants.js }
  end

  def json_for_path_based_graph
    render :json => Views::Tools::PhraseMaker::PhraseCentricGraphPresenter.new(:phrase => @phrase, :grammar_attribute => params[:grammar_attribute]).render
  end

  def json_for_grammar_based_graph
    render :json => Views::Tools::PhraseMaker::GrammarBasedGraphPresenter.new(:phrase => @phrase, :start_role => params[:start_role]).render
  end


private

  def init_phrase
    @phrase = Tools::PhraseMaker::Phrase.load(params[:id])
  end

  def render_create_with_success
    respond_to do |format|
      format.html { redirect_to rest_run.collection_path }
    end
  end

  alias :render_update_with_success :render_create_with_success


  def init_index
    rest_run.current_collection = Tools::PhraseMaker::Phrase.nodes.sort_by do |phrase|
      phrase.name.to_s.downcase.parameterize
    end
  end

  def autocompleter_widget
    widget = Views::Widgets::Misc::AutocompleterResponse.new( :search_term => params[:autocompleter_value] ) do
      [ "name:%s~0.5" % widget.filtered_search_term,  # proximity operator (like near or within)
        "name:%s*" % widget.filtered_search_term ].map do |search_phrase|
        Tools::PhraseMaker::Phrase.find(search_phrase).to_a
      end.flatten.uniq.sort_by(&:name)
    end
  end

end
