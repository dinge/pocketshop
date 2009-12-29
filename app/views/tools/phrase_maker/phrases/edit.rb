class Views::Tools::PhraseMaker::Phrases::Edit < Views::Layouts::Application

  def render_content
    render_gizmo_widget(:gizmo => current_object, :state => controller.action_name)
    render_relationships
  end

  def render_relationships
    Tools::PhraseMaker::Triple::GrammarAttributes.each do |ga|
      widget Views::Tools::PhraseMaker::Widgets::RelationshipsWidget.new(:gizmo => current_object, :method => ga)
    end
  end

end