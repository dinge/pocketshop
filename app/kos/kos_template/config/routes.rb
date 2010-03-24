Rails::Application.routes.draw do |map|
  namespace :kos do
    resources :kos_templates, :controller => :kos_template
  end
end
