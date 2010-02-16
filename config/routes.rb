ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.

  map.root :controller => 'index'

  map.resources :users
  map.resources :teams
  map.resources :concepts do |concept|
    concept.resources :units, :controller => 'concepts/units'
  end
  map.resources :things
  map.resources :tags
  map.resources :me

  map.login '/login', :controller => 'local/sessions', :action => 'new'
  map.logout '/logout', :controller => 'local/sessions', :action => 'destroy'

  map.namespace :local do |local|
    local.resources :sessions
  end

  map.namespace :tools do |tool|
    tool.namespace :phrase_maker do |phrase_maker|
      phrase_maker.resources :phrases,
        :collection => { :autocomplete => :post },
        :member => { :json_for_grammar_based_graph => :get, :phrase_merger => :get }
      phrase_maker.resources :triples
    end

    tool.resources :graph_viewer
  end

  # map.with_options(:namespace => :tools) do |tool|
  #   tool.with_options(:namespace => :phrase_maker) do |phrase_maker|
  #     phrase_maker.resources :phrases
  #   end
  # end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
