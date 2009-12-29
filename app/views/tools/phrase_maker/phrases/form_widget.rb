class Views::Tools::PhraseMaker::Phrases::FormWidget < Views::Widgets::Form::Base

  def content
    form_for @gizmo do |f|
      gizmo_container_widget @gizmo do
        f.text_field :name
      end
    end
    widget Views::Widgets::Gizmo::MetaInfoWidget.new(:gizmo => @gizmo)
  end

end