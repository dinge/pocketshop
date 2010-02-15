module ApplicationHelper

  def render_widget(widget_class, assigns=nil)
    render :text => Erector::Rails.render(widget_class, controller, assigns)
  end

end