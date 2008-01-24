ActionController::Routing::Routes.draw do |map|
  map.resources :sources
  map.resources :types
  
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  
  map.connect '', :controller => 'sources'

  map.connect 'widgeon/:action', :controller => 'widgeon'
  
  map.connect 'source_data/:type/:location', :controller => 'source_data',
              :action => 'show',
              :requirements => { :location => /[^\/]+/ } # Force the location to match also filenames with points etc.
  
  map.connect 'import/:action', :controller => 'import', :action => 'start_import'
  
  
  map.connect ':controller/:id/:attribute', 
              :controller => 'sources', 
              :action => 'show_attribute',
              :id => :nil,
              :attribute => :nil

  map.connect ':controller/:id/:data_type/:location', 
              :controller => 'sources', 
              :action => 'show_source_data',
              :id => :nil,
              :data_type => :nil,
              :location  => :nil,
              :requirements => { :location => /[^\/]+/ } # Force the location to match also filenames with points etc.

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
