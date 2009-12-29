class Views::Tools::PhraseMaker::Phrases::Index < Views::Layouts::Application

  def render_content
    widget Views::Tools::PhraseMaker::Phrases::FormWidget.new(:gizmo => controller.rest_env.model.klass.value_object.new)
    widget Views::Tools::PhraseMaker::Widgets::GizmoWidget.new(:gizmos => current_collection, :state => controller.action_name)
  end

end