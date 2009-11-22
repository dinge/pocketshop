class Views::Widgets::Crud::IndexWidget < Views::Layouts::Application
  def render_content
    current_collection.each do |object|
      text! helpers.quick_view_for(object)
    end
  end
end