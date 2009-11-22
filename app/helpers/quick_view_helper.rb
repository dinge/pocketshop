module QuickViewHelper

  def flash_message
    if notice = flash[:notice]
      notice
    elsif error = flash[:error]
      error
    end
  end

  def quick_view_for(object_or_objects, options = {})
    object = object_or_objects.is_a?(Array) ? object_or_objects.first : object_or_objects
    field_names = filter_field_names(object, object.class.property_names, options)

    content_tag(:fieldset) do
      content_tag(:legend) do
        link_to_object(object) + object_control_for(object)
      end +
      '<dl>' +
        field_names.map do |field_name|
          "<dt>#{field_name}</dt>" +
          "<dd>#{present_field(object.send(field_name))}</dd>"
        end.to_s +
      '</dl>'
    end
  end

  def present_field(value)
    case value
    when DateTime;  value.in_time_zone
    else            value
    end
  end


  def field_set_with_control_for(object, &block)
    control = case object
      when Struct
        klass_name = object.class.name.match("Neo4j::(.*)ValueObject")[1].titleize
        "new #{klass_name}"
      else
        link_to_object(object) + object_control_for(object)
    end

    field_set_tag(control) { capture(&block) }
  end

  def object_control_for(object_or_objects)
    if object_or_objects.is_a?(Array)
      first_part = object_or_objects.second.class.name.underscore
      second_part = object_or_objects.first.class.name.underscore

      control_list_container do
        [
          link_to('(s)',
            send("#{first_part}_#{second_part}_path",
            object_or_objects.second, object_or_objects.first),
            :class => dom_class_for_active_object(:show, controller.action_name),
            :accesskey => 's') ,

          link_to('(e)',
            send("edit_#{first_part}_#{second_part}_path",
            object_or_objects.second, object_or_objects.first),
            :class => dom_class_for_active_object(:edit, controller.action_name),
            :accesskey => 'e') ,

          link_to('(d)',
            send("#{first_part}_#{second_part}_path",
            object_or_objects.second, object_or_objects.first),
            :method => :delete,
            :confirm => 'sure ?',
            :accesskey => 'd')
        ]
      end

    else
      # first_part = object_or_objects.class.name.underscore
      object = object_or_objects

      control_list_container :class => [:object_control, dom_class(object)], :id => dom_id(object, :object_control) do
        [
          link_to('s', object,
            :class => dom_class_for_active_object(:show, controller.action_name),
            :accesskey => 's') ,

          link_to('e', File.join(url_for(object), 'edit'),
            :class => dom_class_for_active_object(:edit, controller.action_name),
            :accesskey => 'e') ,

          link_to('d', object,
            :method => :delete, :confirm => 'sure ?',
            :accesskey => 'd')
        ]
      end
    end
  end

  def collection_control_for
    base_path = File.join("/", controller.class.name.underscore.gsub(/_controller$/, ''))

    control_list_container :container => :div,
      :class => [:collection_control, controller.controller_name],
      :id => join_dom_id_elements(:collection_control, controller.controller_name) do
      [
        link_to('list', base_path,
          :class => dom_class_for_active_object(:index, controller.action_name),
          :accesskey => 'l'),

        link_to('new',
          File.join(base_path, 'new'),
          :class => dom_class_for_active_object(:new, controller.action_name),
          :accesskey => 'n')
      ]
    end
  end

  def quick_form_fields_for(form, options = {})
    field_names = filter_field_names(form.object, form.object.class.property_names, options)
    s = '<dl>'
    field_names.each do |field_name|
      s << "<dt>#{field_name}</dt>"
      s << "<dd>#{form.text_field(field_name, :value => form.object.send(field_name))}</dd>"
    end
    s << '</dl>'
  end

  def filter_field_names(object, field_names, options)
    if except = options[:except]
      field_names - except
    elsif only = options[:only]
      only
    else
      field_names
      # field_names + (object.is_a?(XGen::Mongo::Subobject) ? [] : [:id])
    end
  end

end