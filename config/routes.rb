Ciudadio::Application.routes.draw do
  devise_for :admins, :only => [:sessions]
  namespace :admins do
    get '/' => 'main#index', :as => :index
    
    get '/evaluations' => 'evaluations#index', :as => :evaluations_index
    get '/evaluations/new' => 'evaluations#new', :as => :evaluations_new
    post '/evaluations' => 'evaluations#create', :as => :evaluations
  end
  
  devise_for :users, :only => [:passwords] do
    get "/sign_up", :to => "devise/registrations#new"
    get "/sign_in", :to => "devise/sessions#new", :as => "new_user_session"
    delete "/sign_out", :to => "devise/sessions#destroy", :as => "destroy_user_session"
    
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
  
  namespace :places do
    get 'search' => 'searches#main'
    post 'search' => 'searches#execute_main'
    get '/' => 'listings#index'
    post "/" => "commits#create"
    put ":id" => "commits#update"
    post ":place_id/announcements" => 'commits#announce'
    get ":id/announcements" => 'representations#announcements', :as => "announcements"
    
    
    get ":place_id/comments" => 'comments#index', :as => "comments"
    post ":place_id/comments" => 'comments#create'
    delete ":place_id/comments/:id" => 'comments#destroy', :as => "delete_comment"
    
    get ":place_id/recommendations" => 'recommendations#index', :as => "recommendations"
    put ":place_id/recommendations/on" => 'recommendations#update', :as => 'recommendation_on', :defaults => { :recommend => 'on' }
    put ":place_id/recommendations/off" => 'recommendations#update', :as => 'recommendation_off', :defaults => { :recommend => 'off' }
    
    post ':place_id/evaluations' => 'evaluations#create', :as => "evaluations"
    get ':place_id/evaluations/new' => 'evaluations#new', :as => 'new_evaluation'
    get ":place_id/evaluations/edit/:evaluation_id" => "evaluations#edit", :as => "edit_evaluation"
  end

  get "places/new" => 'places/commits#new', :via => :get, :as => "new_place"
  get "places/:id" => 'places/representations#show', :via => :get, :as => "place"
  get "places/edit/:id" => 'places/commits#edit', :via => :get, :as => "edit_place"
  
  delete "/places/:id/announcements" => 'places/commits#unannounce', :as => "delete_place_announcement"
    
  root :to => 'welcome#index'

end
