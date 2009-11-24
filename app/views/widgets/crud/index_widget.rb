class Views::Widgets::Crud::IndexWidget < Views::Layouts::Application

  def render_content
    render_gizmo_widget(:gizmos => current_collection, :state => controller.action_name)
  end

end