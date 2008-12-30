module ApplicationHelper

  def navigation
    link_to('list', fabrics_path) + ' ' +
    link_to('new', new_fabric_path) + '<hr />'
  end

  def quick_view_for(object, options = {})
    fields = options[:fields] || object.class.field_names + [:id]
    
    s = '<dl>'
    fields.each do |field_name|
      s << "<dt>#{field_name}</dt>"
      s << "<dd>#{object.send(field_name)}</dd>"
    end
    s << '</dl>'
    s << link_to('show', send("#{object.class.name.underscore}_path", object))
    s << " "
    s << link_to('edit', send("edit_#{object.class.name.underscore}_path", object))
    s << " "
    s << link_to('destroy', send("#{object.class.name.underscore}_path", object), :method => :delete, :confirm => 'sure ?')
    s
  end

  def quick_form_fields_for(form)
    s = '<dl>'
    form.object.class.field_names.each do |field_name|
      s << "<dt>#{field_name}</dt>"
      s << "<dd>#{form.text_field(field_name, :value => form.object.send(field_name))}</dd>"
    end
    s << '</dl>'
  end

end
