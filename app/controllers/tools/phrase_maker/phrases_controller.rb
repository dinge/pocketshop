class Tools::PhraseMaker::PhrasesController < ApplicationController
  uses_rest do
    model.klass Tools::PhraseMaker::Phrase
    assets.additional_javascripts 'tools/phrase_maker/phrase_maker'
  end

  def autocomplete
    render_widget autocompleter_widget
  end


private


  def render_create_with_success
    respond_to do |format|
      format.html { redirect_to rest_run.collection_path }
    end
  end

  alias :render_update_with_success :render_create_with_success


  def init_index
    rest_run.current_collection = Tools::PhraseMaker::Phrase.nodes
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
