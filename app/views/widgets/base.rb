class Views::Widgets::Base < Erector::Widget # Erector::RailsWidget
  delegate :current_object, :current_collection, :to => :"controller.rest_run"
end