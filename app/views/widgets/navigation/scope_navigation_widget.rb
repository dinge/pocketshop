class Views::Widgets::Navigation::ScopeNavigationWidget < Views::Widgets::Base

  def content
    div :class => :scope_navigation do
      text! "tags"
    end
  end

end