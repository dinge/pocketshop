class Views::Widgets::Crud::ShowWidget < Views::Layouts::Application
  def render_content
    text! helpers.quick_view_for(current_object)
  end
end