Reciclauc::Application.routes.draw do


  resources :levels


  resources :complaints do
    resources :comments
  end

	match "/404", :to => "errors#not_found"
	match "/500", :to => "errors#internal_server_error"

  
  resources :advertises

  resources :surveys do
    resources :questions
  end

	match "/buildings/:id" => "buildings#show"

  resources :points
  resources :areas
  resources :dumps
  resources :mobile_users
  
  resources :universities do
    resources :reports
    mount Rapidfire::Engine => "/surveys", :as => "rapidfire"
    resources :categories
    resources :types
    resources :complaint_types
    get "statistics/show"
    post "statistics/show"
    post "statistics/campus"
    post "statistics/pors"
    get "statistics/events"
    resources :campuses do
      resources :reports
      #mount Rapidfire::Engine => "/surveys", :as => "rapidfire"
      resources :pois
      resources :pors
      resources :events
      resources :complaints do
        resources :comments
      end
      resources :buildings do
        resources :floors
      end
    end
  end

  authenticated :user do
    root :to => 'universities#index'
  end

  devise_for :users

  devise_scope :user do
     root :to => "devise/sessions#new" 
  end

  # Rutas para asignar y desasignar roles
  match 'user_admin(/:university_id)' => 'users#university_admin', :as => :university_admin_users
  match 'user_admin_campus(/:campus_id)' => 'users#campus_admin', :as => :campus_admin_users
  match 'user_admin/:university_id/remove_admin' => 'users#university_admin_remove', :as => :university_admin_remove
  match 'user_admin/:campus_id/remove_campus_admin' => 'users#campus_admin_remove', :as => :campus_admin_remove

  resources :users, :except =>[:edit] do
    collection do
      post 'campus_admin_create'
      post 'university_admin_create'
      get 'edit_password_current_user'
      get 'edit_current_user'
      get 'edit_roles_user'
      get 'edit_campuses_user'
      put 'update_current_user'
      put ':id/update_roles_user' => 'users#update_roles_user' , :as => 'update_roles_user'
      put ':id/update_campuses_user' => 'users#update_campuses_user' , :as => 'update_campuses_user'
    end
  end
  
  get "default/index"
  post "dumps/download"
  post "events/download"
  post "api/make_complaint"
  
  #-------------------APIs------------------------------------
      #api que retorna los pisos de un edificio
      match "/api/get_building_floors/:building_id/:api_token" => "api#get_building_floors"
      #api que retorna los eventos de la semana
      match "/api/load_week_events/:campus_id/:api_token" => "api#load_week_events"
      #api para crear usuarios de prueba de fb
      match "api/create_test_users/:quantity" => "api#create_test_users"
      #retorna los niveles del juego
      match "api/get_game_levels/:api_token" => "api#get_game_levels"
      #retorna la informacion del juego
      match "api/load_game/:api_token/:access_token" => "api#load_game"
      #retorna la información del perfil
      match "api/show_profile/:university_id/:api_token" => "api#show_profile"
      #retornar tipos de denuncia para universidad dada
      match "api/get_complaint_types/:university_id/:api_token" => "api#get_complaint_types"
      #hacer denuncia desde Android
      match "api/make_complaint/:api_token" => "api#make_complaint"
      #Informacion particular de reciclajes
      match "api/my_recycle_info/:university_id/:api_token" => "api#my_recycle_info"
      #Información particular de eventos
      match "api/my_events_info/:university_id/:api_token" => "api#my_events_info"
      #Recicle API
      match "api/recycle/:dump_id/:api_token" => "api#recycle"
      #Event API
      match "api/check_in/:event_id/:api_token" => "api#check_in"
      #Authentification API
      post "mobile_users/login"
      #Getters
      match "/api/get_universities_and_campuses/:api_token" => "api#get_universities_and_campuses"
      match "/api/get_campus_buildings/:campus_id/:university_id/:api_token" => "api#get_campus_buildings"
      match "/api/get_universities/:api_token" => "api#get_universities"
      match "/api/get_campuses/:api_token" => "api#get_campuses"
      match "/api/load_campus_points/:campus_id/:api_token" => "api#load_campus_points"
      match "/api/load_banner/:campus_id/:api_token" =>"api#load_banner"
      match "/api/get_survey/:campus_survey_id/:api_token" => "api#get_survey"

    #FEED ANDROID
      #get Universities
  #------------------------------------------------------------


  #mount Rapidfire::Engine => "/universities/:university_id/campuses/:campus_id/rapidfire"


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
