class Views::Widgets::Base < Erector::Widget # Erector::RailsWidget
  include Views::Widgets::WidgetHelper
  include Views::Widgets::WidgetCallerHelper

  delegate :current_object, :current_collection, :to => :"controller.rest_run"
  delegate :url_for, :dom_id, :to => :helpers
end