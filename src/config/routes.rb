ActionController::Routing::Routes.draw do |map|
  map.resources :medications

  # The priority is based upon order of creation: first created -> highest priority.

  #######################
  # admin install setup #
  #######################
  map.install "/install", :controller => "install", :action => "index"
  map.adminstatus "/admin/status", :controller => "admin", :action => "status"
  map.connect "/users/setup", :controller => "users", :action => "setup"
  map.connect "database_backup/import", :controller => "database_backup",:action => "import"
  map.connect "database_backup/export", :controller => "database_backup",:action => "export"

  ########
  # Task #
  ########
  map.connect "/patient/:id/tasks/taskcreation/:task_id", :controller => "tasks", :action => "taskcreation"
  map.taskresults "/tasks/results/:id", :controller => "tasks", :action => "results"
  map.taskfill "/tasks/taskfill/:id", :controller => "tasks", :action => "taskfill"
  map.connect "/tasks/createentries", :controller => "tasks", :action => "createentries"
  map.mytasks "users/:user_id/mytasks", :controller => "tasks", :action => "mytasks"


  ###########
  # Patient #
  ###########
  map.connect "/patients/search", :controller => "patients", :action => "search"
  map.admission "/patients/admission", :controller => "patients", :action => "admission"

  ###########
  # Patient #
  ###########
  map.setcaseforview "/patients/:patient_id/case_files/:id/setcaseforview", :controller => "case_files", :action => "setcaseforview"

  ############
  # calendar #
  ############
  map.calendar '/appointments/calendar/:year/:month', :controller => 'appointments', :action => 'calendar', :year => Time.zone.now.year, :month => Time.zone.now.month

  ###########
  # session #
  ###########
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"

  #############
  # resources #
  #############
  map.resources :database_backup, :user_sessions, :users, :catalog_types, :catalogs, :appointments,
                :domains, :patients, :admin, :medical_templates,
                :diagnoses, :tasks, :medical_reports, :report_headers

  map.resources :patients do |patient|
    patient.resources :case_files do |case_file|
      case_file.connect "treatments/new_step2", :controller => "treatments", :action => "new_step2"
      case_file.connect "treatments/new_step3", :controller => "treatments", :action => "new_step3"
      case_file.connect "treatments/new_step4", :controller => "treatments", :action => "new_step4"
      case_file.connect "treatments/new_step5", :controller => "treatments", :action => "new_step5"
      case_file.resources :treatments do |treatment|
        treatment.resources :medications
      end
    end
 
    patient.resources :comments
    patient.resources :medical_reports
    patient.resources :tasks
  end

  map.resources :users do |user|
    user.resources :tasks
  end

  map.resources :permissions, :collection => { :update_all_permissions => :put }

  ############
  # root url #
  ############
  map.root :controller => "patients", :action => "index"

  ###########
  # default #
  ###########
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
