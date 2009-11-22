class Views::Me::IndexWidget < Views::Widgets::Base

  def content
    text "name: #{Me.now.name}"
  end

end