module Kos::PocketUi

  class Engine < Rails::Engine
    # paths.app                 "lib"
    # paths.app.controllers     "controllers"
    # paths.app.helpers         "lib"
    # paths.app.models          "lib"
    # paths.app.mailers         "lib"
    # paths.app.metals          "lib/metal"
    # paths.app.views           "views"
    # paths.lib                 "lib"
    # paths.lib.tasks           "lib/tasks"
    # paths.config              "config"
    # paths.config.initializers "config/initializers"
    # paths.config.locales      "config/locales"
    # paths.config.routes       "config/routes.rb"
    # paths.public              "public"
    # paths.public.javascripts  "public/javascripts"
    # paths.public.stylesheets  "public/stylesheets"

    paths.app                 "lib",                  :eager_load => true, :glob => "*"
    paths.app.controllers     "app",                  :eager_load => true
    paths.app.helpers         "lib",                  :eager_load => true
    paths.app.models          "",                     :eager_load => true
    paths.app.mailers         "lib",                  :eager_load => true
    paths.app.metals          "lib/metal",            :eager_load => true
    paths.app.views           "app/kos/pocket_ui/"
    paths.lib                 "lib",                  :load_path => true
    paths.lib.tasks           "lib/tasks",            :glob => "**/*.rake"
    paths.config              "config"
    paths.config.initializers "config/initializers",  :glob => "**/*.rb"
    paths.config.locales      "config/locales",       :glob => "*.{rb,yml}"
    paths.config.routes       "config/routes.rb"
    paths.public              "public"
    paths.public.javascripts  "public/javascripts"
    paths.public.stylesheets  "public/stylesheets"
  end

end