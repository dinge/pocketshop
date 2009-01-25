module NavigationHelper

  def main_navigation
    control_list_container :container => :div, :id => :main_navigation, :class => :navigation do
      [
        link_to('home', root_path, :accesskey => 'h'),

        link_to('things',
          things_path,
          :class => dom_class_for_active_object(:things, controller.controller_name),
          :accesskey => 't'),

        link_to('concepts',
          concepts_path,
          :class => dom_class_for_active_object(:concepts, controller.controller_name),
          :accesskey => 'c'),

        link_to('tags',
          tags_path,
          :class => dom_class_for_active_object(:tags, controller.controller_name),
          :accesskey => 't'),

        link_to('users',
          sys_users_path,
          :class => dom_class_for_active_object(:users, controller.controller_name),
          :accesskey => 'u')
      ]
    end
  end

  def scope_navigation
    content_tag :div, :class => :scope_navigation do
      tags
    end
  end

  def control_list_container(*args)
    options = args.extract_options!
    container = options.delete(:container) || :span
    join_dom_classes_from_options!(options)

    elements = block_given? ? yield : args.flatten.compact

    content_tag container, options do
      elements.join(' | ')
    end
  end

  def dom_class_for_active_object(first, second)
    first.to_s == second.to_s ? :active : nil
  end

  def link_to_top
    link_to('^', '#top')
  end

  def link_to_object(object)
    link_to(object.name.to_s, File.join(url_for(object), 'edit'))
  end

  def join_dom_classes_from_options!(options)
    if (dom_class = options[:class]).is_a?(Array)
      options[:class] = dom_class.join(' ')
    end
  end

  def join_dom_id_elements(*dom_id_elements)
    dom_id_elements.join('_')
  end

  def footer_navigation
    control_list_container :container => :div, :id => :footer_navigation, :class => :navigation do
      [
        "me: #{link_to(Me.now.name, me_index_path)}",
        "last action at: #{Me.now.last_action_at.to_formatted_s(:db)}"
      ]
    end
  end

end
