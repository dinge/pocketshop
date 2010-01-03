class Views::Tools::PhraseMaker::Phrases::Edit < Views::Layouts::Application

  def render_content
    render_gizmo_widget(:gizmo => current_object, :state => controller.action_name)
    render_relationships
  end

  def render_relationships
    grammar_attributes = Tools::PhraseMaker::Triple::GrammarAttributes

    ul :class => :tab_control do
      grammar_attributes.each do |ga|
        li 'data-tab-id' => 'tab_%s' % ga do
          text 'as %s (%s)' % [ga, current_object.triples_as(ga).size ]
        end
      end
    end

    div :class => :tab_content do
      grammar_attributes.each do |ga|
        div :id => 'tab_%s' % ga, :class => :tools_phrase_maker_triples do
          widget Views::Tools::PhraseMaker::Widgets::RelationshipsWidget.new(
            :gizmo => current_object,
            :method => ga,
            :discard_headline => true )
        end
      end
    end

  end

end