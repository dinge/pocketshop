module Views::Widgets::WidgetCallerHelper

  def gizmo_widget(gizmo, options = {})
    widget Views::Widgets::Gizmo::GizmoWidget.new(:gizmo => gizmo, :options => options)
  end

  def gizmo_container_widget(gizmo, &block)
    widget Views::Widgets::Gizmo::ContainerWidget.new(:gizmo => gizmo, &block)
  end

  def control_list_container(*args, &block)
    options = args.extract_options!
    container = options.delete(:container) || :span
    join_dom_classes_from_options!(options)

    elements = block_given? ? yield : args.flatten.compact

    send(container, options) do
      text! elements.join(' | ')
    end
  end

end