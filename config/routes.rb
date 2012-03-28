Ciudadio::Application.routes.draw do
  #mount TransportAdder::Engine => "/mobility"  
  
  devise_for :admins, :only => [:sessions]
  namespace :admins do
    get '/' => 'main#index', :as => :index
    
    get '/evaluations' => 'evaluations#index', :as => :evaluations_index
    get '/evaluations/new' => 'evaluations#new', :as => :evaluations_new
    post '/evaluations' => 'evaluations#create', :as => :evaluations
  end
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :passwords => "users/passwords" }, :only => [:passwords, :omniauth_callbacks]
  
  devise_scope :user do
    get "/sign_up", :to => "devise/registrations#new"
    get "/sign_in", :to => "devise/sessions#new", :as => "new_user_session"
    delete "/sign_out", :to => "devise/sessions#destroy", :as => "destroy_user_session"
    
    namespace :users do
      post '/auth/create', :to => "omniauth_callbacks#create", :as => :auth_sign_up
      delete '/auth/cancel', :to => "omniauth_callbacks#cancel", :as => :cancel_auth_sign_up
    end
    
    post "/account/create", :to => "devise/registrations#create"
    delete "/account/deactivate", :to => "devise/registrations#destroy"
    get "/account/recover_password", :to => "devise/passwords#new"
    get "/account/reset_password", :to => "devise/passwords#edit", :as => "edit_user_password"

    post "/log_in", :to => "devise/sessions#create", :as => "user_session"
  end
  
  namespace :settings do
    get "account", :via => :get
    get "access", :via => :get
    get "profile", :via => :get
    put "changed", :via => :put
  end
  
  get '/places/' => 'places#index'
  post "/places/" => "places#create"
  put "/places/:id" => "places#update"
  get "/places/new" => 'places#new', :as => "new_place"
  
  namespace :places do
    get 'search' => 'searches#main'
    post 'search' => 'searches#execute_main'
    
    get ":place_id/announcements" => 'announcements#index', :as => "announcements"
    post ":place_id/announcements" => 'announcements#create'
    delete ":place_id/announcements/:id" => 'announcements#destroy', :as => "delete_announcement"
    
    get ":place_id/comments" => 'comments#index', :as => "comments"
    post ":place_id/comments" => 'comments#create'
    delete ":place_id/comments/:id" => 'comments#destroy', :as => "delete_comment"
    
    get ":place_id/recommendations" => 'recommendations#index', :as => "recommendations"
    put ":place_id/recommendations/on" => 'recommendations#update', :as => 'recommendation_on', :defaults => { :recommend => 'on' }
    put ":place_id/recommendations/off" => 'recommendations#update', :as => 'recommendation_off', :defaults => { :recommend => 'off' }
    
    post ':place_id/evaluations/' => 'evaluations#create', :as => "evaluations"
    put ":place_id/evaluations/:id" => "evaluations#update", :as => "evaluation"
    get ':place_id/evaluations/new' => 'evaluations#new', :as => 'new_evaluation'
    get ":place_id/evaluations/edit/:id" => "evaluations#edit", :as => "edit_evaluation"
    get ":place_id/evaluations" => "evaluations#show"
  end
  
  namespace :map do
    resources :street_marks, :only => [:create, :index, :show]
    post "street_marks/rankings" => "street_mark_rankings#create"
    get "street_marks/:street_mark_id/rankings" => "street_marks#rankings"
    
    resources :incidents, :except => [:edit, :update] do
      collection do 
        post :filtering
      end
    end
  end

  resources :bikes do
    collection do 
      get :search
      get :popular
    end
  end

  get "/places/:id" => 'places#show', :as => "place"
  get "/places/edit/:id" => 'places#edit', :as => "edit_place"  
  
  root :to => 'welcome#index'
end
