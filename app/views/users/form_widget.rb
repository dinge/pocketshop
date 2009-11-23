class Views::Users::FormWidget < Views::Widgets::Form::Base

  def content
    form_for @gizmo do |f|
      gizmo_container_widget @gizmo do
        f.label :name
        f.text_field :name

        f.label :password
        f.password_field :password

        f.submit
      end
    end
    widget Views::Widgets::Gizmo::MetaInfoWidget.new(:gizmo => @gizmo)
  end

end
