module Views::Widgets::WidgetCallerHelper

  def render_gizmo_widget(options)
    widget Views::Widgets::Gizmo::GizmoWidget.new(options)
  end

  def gizmo_container_widget(gizmo, &block)
    widget Views::Widgets::Gizmo::ContainerWidget.new(:gizmo => gizmo, &block)
  end

  def form_for(record_or_name_or_array, *args, &proc)
    options = args.extract_options!
    options[:builder] ||= Views::Widgets::Form::FormBuilder
    args.push(options)
    parent.form_for(record_or_name_or_array, *args, &proc)
  end

  def remote_form_for(record_or_name_or_array, *args, &proc)
    options = args.extract_options!
    options[:builder] ||= Views::Widgets::Form::FormBuilder
    args.push(options)
    parent.remote_form_for(record_or_name_or_array, *args, &proc)
  end

  def control_list_container(*args, &block)
    options = args.extract_options!
    container_tag = options.delete(:container_tag) || :ul
    join_dom_classes_from_options!(options)

    elements = block_given? ? yield : args.flatten.compact

    if container_tag == :ul
      ul(options) do
        elements.each do |element|
          li do
            text! element
          end
        end
      end
    else
      send(container_tag, options) do
        text! elements.join(' ')
      end
    end
  end

end