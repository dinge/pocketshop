class Views::Widgets::Crud::ShowWidget < Views::Layouts::Application

  def render_content
    widget Views::Widgets::Gizmos::QuickViewWidget.new(:gizmo => current_object)
  end

end