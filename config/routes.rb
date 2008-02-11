ActionController::Routing::Routes.draw do |map|
  map.resources :sources
  map.resources :types
  map.resources :source_records # needed by will_paginate
  
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

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"
    
  map.connect '', :controller => 'sources', :action => 'show', :id => 'Lucca'

  map.connect 'widgeon/:action', :controller => 'widgeon'
  
  map.connect 'source_data/:type/:location', :controller => 'source_data',
              :action => 'show',
              :requirements => { :location => /[^\/]+/ } # Force the location to match also filenames with points etc.
  
  map.connect 'import/:action', :controller => 'import', :action => 'start_import'
  
  
  map.connect 'sources/:id/:attribute', 
              :controller => 'sources', 
              :action => 'show_attribute',
              :id => :nil,
              :attribute => :nil

#  map.connect ':controller/:id/:data_type/:location', 
#              :controller => 'sources', 
#              :action => 'show_source_data',
#              :id => :nil,
#              :data_type => :nil,
#              :location  => :nil,
#              :requirements => { :location => /[^\/]+/ } # Force the location to match also filenames with points etc.

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
