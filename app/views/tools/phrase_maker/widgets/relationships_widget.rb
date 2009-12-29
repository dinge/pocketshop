class Views::Tools::PhraseMaker::Widgets::RelationshipsWidget < Views::Widgets::Base

  def content
    widget Views::Tools::PhraseMaker::Widgets::GizmoWidget.new( 
              :gizmos => @gizmo.send("triples_as_#{@method}"), 
              :state => :index,
              :discard_headline => true )
  end

end