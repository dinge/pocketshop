class Tools::PhraseMaker::PhrasesController < ApplicationController

  uses_rest do
    model.klass Tools::PhraseMaker::Phrase
    respond_to.js true
    assets do
      additional_javascripts ['vendor/jit-yc', 'visualization/rgraph_setups', 'tools/phrase_maker/phrase_maker']
      additional_stylesheets 'tools/phrase_maker/phrase_maker'
    end
  end

  def autocomplete
    render_widget autocompleter_widget
  end


  def json_for_graph
    phrase = Tools::PhraseMaker::Phrase.load(params[:id])
    end_role = params[:start_role] == 'subject' ? 'object' : 'subject'
    struct = {
      :id => phrase.id,
      :name => phrase.name,
      :data =>  {  
        "$dim" => node_size
      },
      :children => iterate(phrase, params[:start_role], end_role, 10)
    }
    render :json => struct
  end



private

  def node_size(number = 0)
    # 6 - (number * 1)
    4
  end

  def iterate(phrase, start_role, end_role, max_iterations, iteration = 0)
    iteration += 1
    phrase.triples_as(start_role).map do |triple|
      {
        :id => triple.phrase_as(end_role).id,
        :name => triple.phrase_as(end_role).name,
        :data =>  {  
          "$dim" => node_size(iteration)
        },
        :children =>
          iteration < max_iterations ?
            iterate(triple.phrase_as(end_role), start_role, end_role, max_iterations, iteration) :
            []
      }
    end
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
