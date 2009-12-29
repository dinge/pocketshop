class Views::Widgets::Gizmo::ContainerWidget < Views::Widgets::Base

  def content
    fieldset do
      legend do
        if @gizmo.new_record? #is_a?(Struct)
          text "new " << @gizmo.class.short_name
        else
          link_to_gizmo(@gizmo, :method => :edit)
          widget Views::Widgets::Gizmo::ControlWidget.new(:gizmo => @gizmo)
        end
      end
      text! capture(&block)
    end
  end

end