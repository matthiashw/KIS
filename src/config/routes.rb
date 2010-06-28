ActionController::Routing::Routes.draw do |map|
  map.resources :diagnoses

 
  map.connect "/patients/search", :controller => "patients", :action => "search"
  map.calendar '/appointments/calendar/:year/:month', :controller => 'appointments', :action => 'calendar', :year => Time.zone.now.year, :month => Time.zone.now.month
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.resources :report_headers

  map.resources :medical_reports

  map.resources :case_files

  map.resources :user_sessions, :users, :catalog_types, :catalogs, :appointments,
                :domains, :comments, :patients, :admin, :case_files

  map.resources :patients do |patient|
    patient.resources :case_files do |case_file|
      case_file.resources :treatments
    end

    patient.resources :comments

    patient.resources :medical_reports
  end

  map.resources :permissions, :collection => { :update_all_permissions => :put }

  # root url points to this controller
  map.root :controller => "patients", :action => "index"

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

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
