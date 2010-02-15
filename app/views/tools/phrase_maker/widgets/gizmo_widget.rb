class Views::Tools::PhraseMaker::Widgets::GizmoWidget < Views::Widgets::Gizmo::GizmoWidget

private

  def render_index
    h4(headline, :id => dom_class(@gizmos.first, :headline)) if @gizmos.any? && !@discard_headline
    ul(:class => :tools_phrase_maker_triples, :id => :tools_phrase_maker_triples ) do
      @gizmos.each do |gizmo|
        render_show(gizmo)
      end
    end
  end

  def render_show(gizmo = nil)
    gizmo ||= @gizmo
    li :id => dom_id(gizmo), :class => :phrase_maker_gizmo do
      span :class => :wrapper do
        if gizmo.is_a?(Tools::PhraseMaker::Triple)
          link_to_triple(gizmo)
        else
          link_to_phrase(gizmo)
        end
      end
    end
  end


  def headline
    helpers.pluralize(@gizmos.size, @gizmos.first.class.short_name) << @append_to_headline.to_s
  end

  def link_to_triple(triple)
    Tools::PhraseMaker::Triple::GrammarAttributes.map do |ga|
      if phrase = triple.phrase_as(ga)
        link_to_gizmo(phrase, :class => '%s %s' % [ga, dom_id(phrase)])
      else
        text " ... "
      end
    end
    span(:style => 'display:none;', :class => :control) do
      link_to_gizmo(triple, :name => EditIcon) # edit
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