Brkmn::Application.routes.draw do
  resources :users
  resources :urls do 
    collection do
      get 'url_list'
    end
  end
  root :to => 'urls#index'

  # So anything that doesn't match the resource controllers or the root path goes to the redirector controller.

  match '/redirector/invalid' => 'redirector#invalid'

  match '/:id' => 'redirector#index', :as => :shortened
end