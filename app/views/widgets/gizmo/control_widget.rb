class Views::Widgets::Gizmo::ControlWidget < Views::Widgets::Base

  def content
    control_list_container :class => [:object_control, helpers.dom_class(@gizmo)],
      :id => dom_id(@gizmo, :object_control) do
      [
        helpers.link_to('s', @gizmo,
          :class => dom_class_for_active_gizmo(:show, controller.action_name),
          :accesskey => 's') ,

        helpers.link_to('e', File.join(url_for(@gizmo), 'edit'),
          :class => dom_class_for_active_gizmo(:edit, controller.action_name),
          :accesskey => 'e') ,

        helpers.link_to('d', @gizmo,
          :method => :delete, :confirm => 'sure ?',
          :accesskey => 'd')
      ]
    end
  end

end