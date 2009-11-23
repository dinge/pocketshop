class Views::Widgets::Crud::ShowWidget < Views::Layouts::Application

  def render_content
    gizmo_widget(current_object, :state => controller.action_name)
  end

end