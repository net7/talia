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

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # See how all your routes lay out with "rake routes"
  
  # Default route
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => 'home', :action => 'start'

  map.namespace :admin do |admin|
    admin.resources :translations, :collection => { :search => :get }
    admin.resources :users
    admin.resources :sources
    admin.resources :locales
    admin.resources :background, :active_scaffold => true
    admin.resources :custom_templates, :active_scaffold => true
  end

  # Routes for login and users handling
  map.resources :users
  map.login  'login',  :controller => 'sessions', :action => 'create'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'
  map.admin  'admin',  :controller => 'admin',    :action => 'index'
  map.open_id_complete 'session', :controller => 'sessions', :action => 'create', :requirements => { :method => :get }
  map.resource :session
  map.resources :languages, :member => { :change => :get }

  # Routes for the ontologies
  map.resources :ontologies
  
  # Routes for the sources
  map.resources :sources, :requirements => { :id => /.+/  }
  
  # Routes for types
  map.resources :types

  # Routes for hyperedition previews
  map.connect '/preview', :controller => 'preview'
  
  # Routes for the source data
  map.connect 'source_data/:id', :controller => 'source_data',
    :action => 'show'
  map.connect 'source_data/:type/:location', :controller => 'source_data',
    :action => 'show_tloc',
    :requirements => { :location => /[^\/]+/ } # Force the location to match also filenames with points etc.

  map.resources :data_records, :controller => 'source_data'
  
  # Routes for the widget engine
  map.resources :widgeon, :collection => { :callback => :all } do |widgets|
    widgets.connect ':file', :controller => 'widgeon', :action => 'load_file', :requirements => { :file => %r([^;,?]+) }
  end
    
  # Routes for import
  map.connect 'import/:action', :controller => 'import', :action => 'start_import'

  map.connect "texts/:id",
    :controller => 'critical_editions',
    :action => 'show'
  
  map.connect "texts/:id/advanced_search",
    :controller => 'critical_editions',
    :action => 'advanced_search'

    map.connect "texts/:id/auto_complete_for_words",
    :controller => 'critical_editions',
    :action => 'auto_complete_for_words'
  
  map.connect "texts/:id/advanced_search_popup",
    :controller => 'critical_editions',
    :action => 'advanced_search_popup'

  map.connect "texts/:id/advanced_search_print",
    :controller => 'critical_editions',
    :action => 'advanced_search_print'
  
  map.connect "texts/:id/:part",
    :controller => 'critical_editions',
    :action => 'dispatcher'
  
  map.connect "texts/:id/:part/print",
    :controller => 'critical_editions',
    :action => 'print'
  
  map.connect "facsimiles/:id",
    :controller => 'facsimile_editions',
    :action => 'show'
  
  map.connect "facsimiles/:id/search",
    :controller => 'facsimile_editions',
    :action => 'search'

  map.connect "facsimiles/:id/:type/:subtype",
    :controller => 'facsimile_editions',
    :action => 'books',
    :requirements => {:type => /Work|Manuscript|Iconography|Library|Correspondence|Picture/},
    :subtype => nil
    
  map.connect "translations/:action/:id",
    :controller => 'translations',
    :requirements => { :id => /.*/ }

  map.connect "facsimiles/:id/:page/:page2",
    :controller => 'facsimile_editions',
    :action => 'double_pages',
    :requirements => {:page => /.*,[^\.]*/, :page2 => /.*,[^\.]*/}
  
  map.connect "facsimiles/:id/:page:dot:format",
    :controller => 'facsimile_editions',
    :action => 'page',
    :dot => /\.?/,
    :requirements => {:page => /.*,[^\.]*/},
    :defaults => {:format => 'html'}
  
  map.connect "facsimiles/:id/:book:dot:format",
    :controller => 'facsimile_editions',
    :action => 'panorama',
    :dot => /\.?/,
    :defaults => {:format => 'html'}


  map.connect "categories/advanced_search",
    :controller => 'categories',
    :action => 'advanced_search'
  
  map.connect "series/advanced_search",
    :controller => 'series',
    :action => 'advanced_search'

  map.resources :av_media_sources, :categories, :keywords, :series, :sources
  map.resources :tags, :controller => "keywords"

  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'  
  
  map.resources :FE do |facsimile_edition|
    facsimile_edition.resource :book do |book|
      book.resources :pages
    end
  end
  
end
