class Views::Users::FormWidget < Views::Widgets::Base

  def content
    form_for current_object do |f|
      helpers.field_set_with_control_for current_object do
        f.label :name
        f.text_field :name

        f.label :password
        f.password_field :password

        f.submit
      end
    end
  end

end
