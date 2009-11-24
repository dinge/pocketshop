class Views::Widgets::Gizmo::ContainerWidget < Views::Widgets::Base

  def content
    fieldset do
      legend do
        if @gizmo.new_record? #is_a?(Struct)
          text "new " << @gizmo.class.model_name
        else
          link_to_gizmo(@gizmo, :edit)
          widget Views::Widgets::Gizmo::ControlWidget.new(:gizmo => @gizmo)
        end
      end
      text! capture(&block)
    end
  end

end