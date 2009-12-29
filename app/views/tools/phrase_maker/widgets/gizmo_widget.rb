class Views::Tools::PhraseMaker::Widgets::GizmoWidget < Views::Widgets::Gizmo::GizmoWidget

private

  def render_index
    h4 headline if @gizmos.any? && !@discard_headline
    ul do
      @gizmos.each do |gizmo|
        li do
          if gizmo.is_a?(Tools::PhraseMaker::Triple)
            link_to_triple(gizmo)
          else
            link_to_gizmo(gizmo)
            text! helpers.destroy_link_with_confirmation(gizmo, :method => :delete)
          end
        end
      end
    end
  end

  def headline
    helpers.pluralize(@gizmos.size, @gizmos.first.class.short_name) << @append_to_headline.to_s 
  end

  def link_to_triple(gizmo)
    link_to_gizmo(gizmo, :name => '&#9998;') # edit
    text! helpers.destroy_link_with_confirmation(gizmo, :method => :delete)
    Tools::PhraseMaker::Triple::GrammarAttributes.map do |ga|
      link_to_gizmo(gizmo.send("phrase_as_#{ga}"))
    end 
  end

end