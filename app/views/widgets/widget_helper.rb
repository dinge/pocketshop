module Views::Widgets::WidgetHelper

  def join_dom_classes_from_options!(options)
    if (dom_class = options[:class]).is_a?(Array)
      options[:class] = dom_class.join(' ')
    end
  end

  def dom_class_for_active_gizmo(first, second)
    first.to_s == second.to_s ? :active : nil
  end

  def flash_message
    flash[:error] || flash[:notice]
  end

  def join_dom_id_elements(*dom_id_elements)
    dom_id_elements.join('_')
  end

  def dom_classes(*dom_classes)
    dom_classes.flatten.join(' ')
  end

  def link_to_gizmo(gizmo, method = :edit)
    link_to(gizmo.name.to_s, File.join(url_for(gizmo), method.to_s))
  end

  def link_to_top
    link_to('^', '#top')
  end

  def notice_message(*messages)
    system_message(messages, :notice_message)
  end

  def important_message(*messages)
    system_message(messages, :important_message)
  end

  def warning_message(*messages)
    system_message(messages, :warning_message)
  end

  def system_message(messages, dom_class = :warning_message)
    ul :class => dom_classes(:system_message, dom_class) do
      messages.flatten.each do |message|
        li message
      end
    end
  end

  # def submit_button(label = 'save changes', options = {})
  #   options = options.reverse_merge(:type => :submit)
  #   content_tag(:button, label, options)
  # end

end