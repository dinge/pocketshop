class Views::Tags::FormWidget < Views::Widgets::Form::Base

  def content
    form_for @gizmo do |f|
      gizmo_container_widget @gizmo do
        f.label :name
        f.text_field :name
        f.submit
      end
    end
    widget Views::Widgets::Gizmo::MetaInfoWidget.new(:gizmo => @gizmo)
  end

end

