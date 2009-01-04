module QuickViewHelper

  def quick_view_for(object_or_objects, options = {})
    object = object_or_objects.is_a?(Array) ? object_or_objects.first : object_or_objects
    field_names = filter_field_names(object, object.class.field_names, options)

    s = '<dl>'
    field_names.each do |field_name|
      s << "<dt>#{field_name}</dt>"
      s << "<dd>#{object.send(field_name)}</dd>"
    end
    s << '</dl>'

    s << quick_object_control(object_or_objects)
  end

  def quick_object_control(object_or_objects)
    # edit_concept_unit_path(1, object_or_objects)
    s = ''
    if object_or_objects.is_a?(Array)
      first_part = object_or_objects.second.class.name.underscore
      second_part = object_or_objects.first.class.name.underscore
      s << link_to('show', send("#{first_part}_#{second_part}_path", object_or_objects.second, object_or_objects.first))
      s << " "
      s << link_to('edit', send("edit_#{first_part}_#{second_part}_path", object_or_objects.second, object_or_objects.first))
      s << " "
      s << link_to('destroy', send("#{first_part}_#{second_part}_path", 
            object_or_objects.second, object_or_objects.first), :method => :delete, :confirm => 'sure ?')
    else
      first_part = object_or_objects.class.name.underscore
      object = object_or_objects
      s << link_to('show', send("#{first_part}_path", object))
      s << " "
      s << link_to('edit', send("edit_#{first_part}_path", object))
      s << " "
      s << link_to('destroy', send("#{first_part}_path", object), :method => :delete, :confirm => 'sure ?')
    end
    s
  end

  def quick_form_fields_for(form, options = {})
    field_names = filter_field_names(form.object, form.object.class.field_names, options)
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
      field_names + (object.is_a?(XGen::Mongo::Subobject) ? [] : [:id])
    end
  end

end