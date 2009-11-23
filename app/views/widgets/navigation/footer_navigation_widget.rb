class Views::Widgets::Navigation::FooterNavigationWidget < Views::Widgets::Base

  def content
    control_list_container :container => :div, :id => :footer_navigation, :class => :navigation do
      [
       "me: #{helpers.link_to(Me.now.name, me_index_path)}",
        # "last action: #{ link_to(Me.now.last_action, Me.now.last_action) }",
        # "last action at: #{ Me.now.last_action_at.to_formatted_s(:db) }",
        helpers.link_to('logout', logout_path, :method => :delete)
      ]
    end
  end

end

