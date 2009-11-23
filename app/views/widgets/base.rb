class Views::Widgets::Base < Erector::Widget # Erector::RailsWidget
  delegate :current_object, :current_collection, :to => :"controller.rest_run"
  delegate :url_for, :dom_id, :to => :helpers


  def control_list_container(*args, &block)
    options = args.extract_options!
    container = options.delete(:container) || :span
    join_dom_classes_from_options!(options)

    elements = block_given? ? yield : args.flatten.compact

    send(container, options) do
      text! elements.join(' | ')
    end
  end

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

  def link_to_edit_gizmo(gizmo)
    link_to(gizmo.name.to_s, File.join(url_for(gizmo), 'edit'))
  end

  def link_to_top
    link_to('^', '#top')
  end

  # def submit_button(label = 'save changes', options = {})
  #   options = options.reverse_merge(:type => :submit)
  #   content_tag(:button, label, options)
  # end

end