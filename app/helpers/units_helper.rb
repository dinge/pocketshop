module UnitsHelper

  def fieldset_name_for_unit(unit, concept)
    if unit.new_record?
      'new unit'
    else
      unit.name + 
      content_tag(:span, :class => :object_control) do
        control_list_container(
          link_to_top ,
          unit.new_record? ? nil : link_to('d', 
                                     concept_unit_path(concept, unit), 
                                     :method => :delete, 
                                     :confirm => 'sure?') )
      end
    end

  end

end
