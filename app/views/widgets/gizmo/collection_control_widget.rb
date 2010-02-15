class Views::Widgets::Gizmo::CollectionControlWidget < Views::Widgets::Base

  def content
    base_path = File.join("/", controller.class.name.underscore.gsub(/_controller$/, ''))

    control_list_container :class => [:collection_control, :navigation, controller.controller_name],
      :id => join_dom_id_elements(:collection_control, controller.controller_name) do
      [
        helpers.link_to(ListIcon,
          base_path,
          :class => dom_class_for_active_gizmo(:index, controller.action_name),
          :accesskey => 'l',
          :title => 'list'),

        helpers.link_to(NewIcon,
          File.join(base_path, 'new'),
          :class => dom_class_for_active_gizmo(:new, controller.action_name),
          :accesskey => 'n',
          :title => 'new')
      ]
    end
  end

end