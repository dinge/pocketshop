class Views::Widgets::Form::FormBuilder < Erector::RailsFormBuilder
  include Erector::Mixin

  def text_field_with_autocompleter(field_name, options, &block)
    autocompleter_path = template.send(options.delete(:path), :authenticity_token => template.form_authenticity_token )

    options = options.merge(:class => :clear_value_on_click)
    template.concat( parent.text_field(field_name, options) )
    template.concat(
      erector do
        div :class => :autocomplete, :id => "#{field_name}_autocomplete_choices"
        javascript do
          rawtext autocompleter_object(field_name, autocompleter_path)
        end
      end
    )
  end


private

  def autocompleter_object(field_name, path)
    <<-"END"
      new Ajax.Autocompleter(
          "#{@parent.object_name}_#{field_name}",
          "#{field_name}_autocomplete_choices",
          "#{path}",
          { paramName: "autocompleter_value",
            frequency: 0.3,
            tokens: ['\\n'] }
      );
    END
  end

end