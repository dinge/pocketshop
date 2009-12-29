class Views::Widgets::Navigation::ScopeNavigationWidget < Views::Widgets::Base

  def content
    div :id => :scope_navigation do
      text! "tags"
    end
  end

end