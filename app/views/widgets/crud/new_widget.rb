class Views::Widgets::Crud::NewWidget < Views::Layouts::Application

  def render_content
    render_gizmo_widget(:gizmo => current_object, :state => controller.action_name)
  end

end