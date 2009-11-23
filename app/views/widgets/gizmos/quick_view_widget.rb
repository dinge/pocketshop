class Views::Widgets::Gizmos::QuickViewWidget < Views::Widgets::Base

  def content
    fieldset do
      legend do
        link_to_edit_gizmo(@gizmo)
        text gizmo_control_for(@gizmo)
      end
      dl do
        field_names.map do |field_name|
          dt field_name
          dd present_field(@gizmo.send(field_name))
        end
      end
    end
  end


private

  def field_names
    filter_field_names(@gizmo.class.property_names) #, options
  end

  def filter_field_names(field_names, options = {})
    if except = options[:except]
      field_names - except
    elsif only = options[:only]
      only
    else
      field_names
    end
  end

  def present_field(value)
    case value
    when DateTime;  value.in_time_zone
    else            value
    end
  end

  def gizmo_control_for(gizmo)
    control_list_container :class => [:object_control, helpers.dom_class(gizmo)],
      :id => dom_id(gizmo, :object_control) do
      [
        helpers.link_to('s', gizmo,
          :class => dom_class_for_active_gizmo(:show, controller.action_name),
          :accesskey => 's') ,

        helpers.link_to('e', File.join(url_for(gizmo), 'edit'),
          :class => dom_class_for_active_gizmo(:edit, controller.action_name),
          :accesskey => 'e') ,

        helpers.link_to('d', gizmo,
          :method => :delete, :confirm => 'sure ?',
          :accesskey => 'd')
      ]
    end
  end

end