class Views::Widgets::Gizmo::ContainerWidget < Views::Widgets::Base

  def content
    fieldset do
      legend do
        if @gizmo.new_record? #is_a?(Struct)
          text "new " << @gizmo.class.name.match("Neo4j::(.*)ValueObject")[1].titleize
        else
          widget Views::Widgets::Gizmo::ControlWidget.new(:gizmo => @gizmo)
        end
      end
      text! capture(&block)
    end
  end

end