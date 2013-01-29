Brkmn::Application.routes.draw do
  get 'log_in' => 'sessions#new', :as => 'log_in'
  get 'log_out' => 'sessions#destroy', :as => 'log_out'

  get 'sign_up' => 'users#new', :as => "sign_up"
  root :to => 'sessions#new'
  resources :users
  resources :sessions
  resources :password_resets
  
  resources :urls do 
    collection do
      get 'url_list'
      get 'bookmarklet'
      get 'search', :path => 'search(/:search)'
    end
  end

  # So anything that doesn't match the resource controllers or the root path goes to the redirector controller.

  match '/redirector/invalid' => 'redirector#invalid'

  match '/:id' => 'redirector#index', :as => :shortened
  
  match '/urls/:id' => 'urls#reset', :via => 'post', :as => :reset
  
end