class Views::Tools::PhraseMaker::Triples::Edit < Views::Layouts::Application

  def render_content
    render_gizmo_widget(:gizmo => current_object, :state => :edit)
    render_relationsips
  end

  def render_relationsips
    grammar_attributes = Tools::PhraseMaker::Triple::GrammarAttributes

    ul :class => :tab_control do
      grammar_attributes.each do |ga|
        phrase = current_object.phrase_as(ga)
        li 'data-tab-id' => dom_id(phrase, 'tab') do
          text '%s (%s)' % [phrase.name, phrase.triples.to_a.size]
        end
      end
    end

    div :class => :tab_content do
      grammar_attributes.each do |ga|
        phrase = current_object.phrase_as(ga)
        dl :id => dom_id(phrase, :tab) do
          grammar_attributes.each do |gs|
            dt do
              text link_to_gizmo(phrase).to_s << ' as %s (%s)' % [gs, phrase.triples_as(gs).to_a.size]
            end
            dd do
              widget Views::Tools::PhraseMaker::Widgets::RelationshipsWidget.new(
                :gizmo => phrase,
                :method => gs,
                :discard_headline => true )
            end
          end
        end
      end
    end
  end

end