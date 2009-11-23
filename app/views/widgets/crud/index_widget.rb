class Views::Widgets::Crud::IndexWidget < Views::Layouts::Application

  def render_content
    current_collection.each do |gizmo|
      widget Views::Widgets::Gizmos::QuickViewWidget.new(:gizmo => gizmo)
    end
  end

end