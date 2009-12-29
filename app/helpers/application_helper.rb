module ApplicationHelper
  def destroy_link_with_confirmation(*args)
    options      = args.first || {}
    html_options = args.second

    dom_id_suffix       = rand(self.object_id)
    confirmation_dom_id = "destroy_confirmation_%s" % dom_id_suffix
    cancel_dom_id       = "destroy_confirmation_cancel_%s" % dom_id_suffix
    accept_dom_id       = "destroy_confirmation_accept_%s" % dom_id_suffix

    link_to_function(
      "&#9747;", :id => confirmation_dom_id) do |page|
      page[confirmation_dom_id].toggle
      page[cancel_dom_id].toggle
      page[accept_dom_id].toggle
    end +

    link_to_function(
      "  &#10007; ",
        :id => cancel_dom_id, :style => 'display:none;') do |page|
      page[confirmation_dom_id].toggle
      page[cancel_dom_id].toggle
      page[accept_dom_id].toggle
    end +

    link_to(' &#10004; ',
      options,
      html_options.merge(:id => accept_dom_id, :style => 'display:none;'))
  end
end