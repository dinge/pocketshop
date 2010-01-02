class Views::Tools::PhraseMaker::Triples::FormWidget < Views::Widgets::Form::Base

  def content
    remote_form_for @gizmo do |f|
      gizmo_container_widget @gizmo do

        f.text_field_with_autocompleter  :subject_name,
                      :size => 18,
                      :value => @gizmo.subject_name,
                      :path => :autocomplete_tools_phrase_maker_phrases_path

        f.text_field_with_autocompleter  :predicate_name,
                      :size => 18,
                      :value => @gizmo.predicate_name,
                      :path => :autocomplete_tools_phrase_maker_phrases_path

        f.text_field_with_autocompleter  :object_name,
                      :size => 18,
                      :value => @gizmo.object_name,
                      :path => :autocomplete_tools_phrase_maker_phrases_path

        f.submit 'save'
      end
    end
    widget Views::Widgets::Gizmo::MetaInfoWidget.new(:gizmo => @gizmo)
  end

end