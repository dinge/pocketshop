xml.dl do
  @items.each do |item|
    xml.dt "name"
    xml.dd item.name
    xml.dt "render partial definition"
    xml.dd render(:partial => 'here_with_xml')
    xml.dt "text from helper"
    xml.dd xml_helper_text
  end
end