module Views::Widgets::Gizmo::GizmoHelper

  def link_to_triple(triple)
    Tools::PhraseMaker::Triple::GrammarAttributes.map do |ga|
      if phrase = triple.phrase_as(ga)
        link_to_gizmo(phrase, :class => '%s %s' % [ga, dom_id(phrase)])
      else
        text " ... "
      end
    end
    span(:style => 'display:none;', :class => :control) do
      link_to_gizmo(triple, :name => Views::Widgets::WidgetHelper::EditIcon) # edit
      destroy_link_with_confirmation(triple, :remote => :true)
    end
  end

  def link_to_phrase(phrase)
    link_to_gizmo(phrase)
    span(:style => 'display:none;', :class => :control) do
      destroy_link_with_confirmation(phrase, :remote => :true)
    end
  end

end