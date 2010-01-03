class Views::Tools::PhraseMaker::Phrases::Index < Views::Layouts::Application

  def render_content
    widget Views::Tools::PhraseMaker::Phrases::FormWidget.new(:gizmo => controller.rest_env.model.klass.value_object.new)
    render_tabs
  end
  
  
  def render_tabs
    grammar_attributes = Tools::PhraseMaker::Triple::GrammarAttributes

    ul :class => :tab_control do
      li 'data-tab-id' => 'tab_all' do
        text '%s (%s)' % ['all', current_collection.size ]
      end
      grammar_attributes.each do |ga|
        li 'data-tab-id' => 'tab_%s' % ga do
          text '%s (%s)' % [ga.pluralize, Tools::PhraseMaker::Phrase.filter_by_grammar_attribute(current_collection, ga).size ]
        end
      end
    end

    div :class => :tab_content do
      div :id => 'tab_all', :class => :tools_phrase_maker_phrases do
        widget Views::Tools::PhraseMaker::Widgets::GizmoWidget.new(
          :gizmos => current_collection, 
          :state => :index, 
          :discard_headline => true )
      end
      grammar_attributes.each do |ga|
        div :id => 'tab_%s' % ga, :class => :tools_phrase_maker_phrases do
          widget Views::Tools::PhraseMaker::Widgets::GizmoWidget.new(
            :gizmos => Tools::PhraseMaker::Phrase.filter_by_grammar_attribute(current_collection, ga), 
            :state => :index, 
            :discard_headline => true )
        end
      end
    end
  end

end