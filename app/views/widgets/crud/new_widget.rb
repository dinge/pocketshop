class Views::Widgets::Crud::NewWidget < Views::Layouts::Application

  def render_content
    gizmo_widget(current_object, :state => controller.action_name)
  end

end