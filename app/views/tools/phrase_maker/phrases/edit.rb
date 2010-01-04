class Views::Tools::PhraseMaker::Phrases::Edit < Views::Layouts::Application

  def render_content
    render_gizmo_widget(:gizmo => current_object, :state => controller.action_name)
    render_relationships
  end

  def render_relationships
    grammar_attributes = Tools::PhraseMaker::Triple::GrammarAttributes

    ul :class => :tab_control, 'data-tab-options-callback' => 'Tools.PhraseMaker.Tabs.Options'  do
      li 'data-tab-id' => 'tab_all' do
        text '%s (%s)' % ['all', current_object.triples.to_a.size ]
      end
      grammar_attributes.each do |ga|
        li 'data-tab-id' => 'tab_%s' % ga  do
          text 'as %s (%s)' % [ga, current_object.triples_as(ga).size ]
        end
      end
      li 'data-tab-id' => 'tab_phrase_merger' do
        text 'Phrase-Merger'
      end
    end

    div :class => :tab_content do
      div :id => 'tab_all', :class => :tools_phrase_maker_triples do
        widget Views::Tools::PhraseMaker::Widgets::GizmoWidget.new(
          :gizmos => current_object.triples.to_a, 
          :state => :index, 
          :discard_headline => true )
      end
      grammar_attributes.each do |ga|
        div :id => 'tab_%s' % ga, :class => :tools_phrase_maker_triples do
          widget Views::Tools::PhraseMaker::Widgets::RelationshipsWidget.new(
            :gizmo => current_object,
            :method => ga,
            :discard_headline => true )
          div '', :id => 'graph_visualization_for_%s' % ga if %w(subject object).include?(ga)
        end
      end
      div :id => 'tab_phrase_merger' do
        widget Views::Tools::PhraseMaker::Widgets::PhraseMergerWidget.new(:phrase => current_object)
      end
    end

  end

end