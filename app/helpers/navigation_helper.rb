module NavigationHelper

  def navigation
    link_to('list', concepts_path) + ' ' +
    link_to('new', new_concept_path) + '<hr />'
  end

  def main_navigation
    link_to('home', root_path) + ' - ' +
    link_to('things', things_path) + ' - ' +
    link_to('concepts', concepts_path)
  end

end
