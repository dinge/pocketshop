class Views::Tools::PhraseMaker::Triples::Edit < Views::Layouts::Application

  def render_content
    render_gizmo_widget(:gizmo => current_object, :state => controller.action_name)

    # Tools::PhraseMaker::Triple::GrammarAttributes.each do |ga|
    #   render_relationships( current_object.send("phrase_as_#{ga}") )
    # end

    grammar_attributes = Tools::PhraseMaker::Triple::GrammarAttributes

    p do
      table do
        thead do
          th ''
          grammar_attributes.each do |ga|
            th do 
              link_to_gizmo( current_object.send("phrase_as_#{ga}") ) # link to the phrase in header
            end 
          end
        end
        tbody do
          grammar_attributes.each do |ga|
            tr do
              td ga
              grammar_attributes.each do |gs|
                td do
                  widget Views::Tools::PhraseMaker::Widgets::RelationshipsWidget.new( 
                    :gizmo => current_object.send("phrase_as_#{gs}"), 
                    :method => ga )
                end
              end
            end
          end
        end
      end
    end

  end

  # def render_relationships(phrase)
  #   h3 { link_to_gizmo(phrase) }
  #   Tools::PhraseMaker::Triple::GrammarAttributes.each do |ga|
  #     widget Views::Tools::PhraseMaker::Widgets::RelationshipsWidget.new( :gizmo => phrase, :method => ga )
  #   end
  # end

  # def render_relationships(phrase)
  #   h3 { link_to_gizmo(phrase) }
  #   Tools::PhraseMaker::Triple::GrammarAttributes.each do |ga|
  #     widget Views::Tools::PhraseMaker::Widgets::RelationshipsWidget.new( :gizmo => phrase, :method => ga )
  #   end
  # end

end