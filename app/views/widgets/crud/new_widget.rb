class Views::Widgets::Crud::NewWidget < Views::Layouts::Application
  def render_content
    widget Views::Widgets::Forms::DefaultFormWidget
  end
end