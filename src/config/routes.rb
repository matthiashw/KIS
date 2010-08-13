ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  map.install "/install", :controller => "install", :action => "index"

  map.adminstatus "/admin/status", :controller => "admin", :action => "status"
  map.connect "/users/setup", :controller => "users", :action => "setup"


  map.connect "/patient/:id/tasks/taskcreation/:task_id", :controller => "tasks", :action => "taskcreation"
  map.taskresults "/tasks/results/:id", :controller => "tasks", :action => "results"
  map.taskfill "/tasks/taskfill/:id", :controller => "tasks", :action => "taskfill"
  map.connect "/tasks/createentries", :controller => "tasks", :action => "createentries"

  map.connect "/patients/search", :controller => "patients", :action => "search"
  map.calendar '/appointments/calendar/:year/:month', :controller => 'appointments', :action => 'calendar', :year => Time.zone.now.year, :month => Time.zone.now.month
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"

  map.resources :user_sessions, :users, :catalog_types, :catalogs, :appointments,
                :domains, :patients, :admin, :case_files , :medical_templates,
                :diagnoses, :tasks, :medical_reports, :report_headers

  map.resources :patients do |patient|
    patient.resources :case_files do |case_file|
      case_file.resources :treatments
    end

    patient.resources :comments
    patient.resources :medical_reports
    patient.resources :tasks
  end
  map.resources :permissions, :collection => { :update_all_permissions => :put }


  # root url points to this controller
  map.root :controller => "patients", :action => "index"

  
  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
