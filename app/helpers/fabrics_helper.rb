module FabricsHelper

  def navigation
    link_to('list', fabrics_path) + ' ' +
    link_to('new', new_fabric_path) + '<hr />'
  end

end
