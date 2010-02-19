class Views::Tools::PhraseMaker::Widgets::RelationshipsWidget < Views::Widgets::Base

  def content
    case @method.to_sym
    when :subject, :predicate
      render_grouped_gizmos(@gizmo, @method, :subject, :predicate)
    when :object
      render_grouped_gizmos(@gizmo, @method, :predicate, :object)
    end
  end

private

  def render_grouped_gizmos(gizmo, grammar_attribute, first_grammar_attribute, last_grammar_attribute)
    gizmo.triples_as(grammar_attribute).to_a.group_by do |triple|
      [triple.phrase_as(first_grammar_attribute), triple.phrase_as(last_grammar_attribute)]
    end.sort_by do |grouper_phrases, grouped_triples|
      grouper_phrases.first.name
    end.each do |grouper_phrases, triples|
      link_to_phrase(grouper_phrases.first)
      link_to_phrase(grouper_phrases.last)
      widget Views::Tools::PhraseMaker::Widgets::GizmoWidget.new(
                :gizmos => triples,
                :state => :index,
                :discard_headline => true )
    end
  end

end