class Tools::PhraseMaker::TriplesController < ApplicationController
  uses_rest do
    model.klass Tools::PhraseMaker::Triple
    respond_to.js true 
    assets do
      additional_javascripts 'tools/phrase_maker/phrase_maker'
      additional_stylesheets 'tools/phrase_maker/phrase_maker'
    end
  end


private

  def render_create_with_success
    respond_to do |format|
      format.html { redirect_to rest_run.collection_path }
      format.js
    end
  end

  def render_update_with_success
    respond_to do |format|
      format.html { redirect_to rest_run.collection_path }
      format.js
    end
  end


  def init_index
    rest_run.current_collection = rest_run.my_created_collection.sort_by do |triple|
      triple.subject_name.to_s.downcase.parameterize
    end
  end

  def operate_create
    super
    connect_phrases
  end

  def operate_update
    super
    connect_phrases
  end

  def connect_phrases
    Tools::PhraseMaker::Triple::GrammarAttributes.each do |ga|
      rest_run.current_object.send("phrase_as_#{ga}=", 
        Tools::PhraseMaker::Phrase.existing_or_new_phrase(rest_run.current_params_hash["#{ga}_name"]) )
    end
  end

end
