class Views::Tools::PhraseMaker::Widgets::RelationshipsWidget < Views::Widgets::Base

  def content
    widget Views::Tools::PhraseMaker::Widgets::GizmoWidget.new( 
              :gizmos => @gizmo.triples_as(@method), 
              :state => :index,
              :discard_headline => false )
  end

end