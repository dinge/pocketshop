class Views::Widgets::Gizmo::ControlWidget < Views::Widgets::Base

  def content

    control_list_container :class => [:object_control, helpers.dom_class(@gizmo)],
      :id => dom_id(@gizmo, :object_control),
      :container_tag => :span do
      [
        helpers.link_to(ShowIcon, @gizmo, # show
          :class => dom_class_for_active_gizmo(:show, controller.action_name),
          :accesskey => 's',
          :title => :show) ,

        helpers.link_to(EditIcon, File.join(url_for(@gizmo), 'edit'), # edit
          :class => dom_class_for_active_gizmo(:edit, controller.action_name),
          :accesskey => 'e',
          :title => :edit) ,

      ]
    end
  end

end