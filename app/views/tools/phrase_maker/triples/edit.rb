class Views::Tools::PhraseMaker::Triples::Edit < Views::Layouts::Application

  def render_content
    render_gizmo_widget(:gizmo => current_object, :state => controller.action_name)

    grammar_attributes = Tools::PhraseMaker::Triple::GrammarAttributes

    ul :class => :tab_control do
      grammar_attributes.each do |ga|
        phrase = current_object.phrase_as(ga)
        li 'data-tab-id' => dom_id(phrase, '#tab') do
          text phrase.name
        end
      end
    end

    div :class => :tab_content do
      grammar_attributes.each do |ga|
        phrase = current_object.phrase_as(ga)
        dl :id => dom_id(phrase, :tab) do
          grammar_attributes.each do |gs|
            dt do
              text 'as %s' % gs
            end
            dd do
              widget Views::Tools::PhraseMaker::Widgets::RelationshipsWidget.new(
                :gizmo => phrase,
                :method => gs )
            end
          end
        end
      end
    end



    # div :id => :subject_tab do
    #   text "subject"
    # end
    #
    # div :id => :predicate_tab do
    #   text "predicate"
    # end
    #
    # div :id => :object_tab do
    #   text "object"
    # end


  #   p do
  #     table do
  #       thead do
  #         tr do
  #           th ''
  #           grammar_attributes.each do |ga|
  #             th do
  #               if value = current_object.send("phrase_as_#{ga}")
  #                 link_to_gizmo( value ) # link to the phrase in header
  #               end
  #             end
  #           end
  #         end
  #       end
  #       tbody do
  #         grammar_attributes.each do |ga|
  #           tr do
  #             td ga
  #             grammar_attributes.each do |gs|
  #               td do
  #                 widget Views::Tools::PhraseMaker::Widgets::RelationshipsWidget.new(
  #                   :gizmo => current_object.send("phrase_as_#{gs}"),
  #                   :method => ga )
  #               end
  #             end
  #           end
  #         end
  #       end
  #     end
  #   end
  #
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