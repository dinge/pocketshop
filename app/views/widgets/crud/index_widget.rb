class Views::Widgets::Crud::IndexWidget < Views::Layouts::Application

  def render_content
    current_collection.each { | gizmo | gizmo_widget(gizmo, :state => controller.action_name) }
  end

end