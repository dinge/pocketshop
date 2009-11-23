class Views::Widgets::Gizmo::MetaInfoWidget < Views::Widgets::Base

  def content
    unless @gizmo.new_record?
      control_list_container :class => :node_meta_info do
        [ (@gizmo.creator.name rescue nil),
          @gizmo.created_at.to_s(:db),
          @gizmo.updated_at.to_s(:db),
          @gizmo.version ].compact
      end
    end
  end

end