module FormHelper

  def submit_button(label = 'save changes', options = {})
    options = options.reverse_merge(:type => :submit)
    content_tag(:button, label, options)
  end

end