module NavigationHelper

  def main_navigation
    control_list_container do
      [
        link_to('home', root_path, :accesskey => 'h'),
    
        link_to('things', 
          things_path, 
          :class => dom_class_for_active_object('things', controller.controller_name),
          :accesskey => 't'),
      
        link_to('concepts', 
          concepts_path,
          :class => dom_class_for_active_object('concepts', controller.controller_name),
          :accesskey => 'c')
      ]
    end
  end

  def control_list_container(*elements)
    elements = block_given? ? yield : elements.flatten.compact
    elements.join(' | ')
  end

  def dom_class_for_active_object(first, second)
    first.to_s == second.to_s ? :active : nil
  end

  def link_to_top
    link_to('^', '#top')
  end

end
