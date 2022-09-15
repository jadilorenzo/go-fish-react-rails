Rails.application.routes.draw do
  get 'session/new'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'games#index'
  get '/styleguide', to: 'styleguide#index'
  resources :users
  get '/signup', to: 'users#new'
  get '/stats', to: 'static_pages#stats'
  get '/login', to: 'session#new'
  get '/over/:id', to: 'games#over', as: 'game_over'
  resources :games do
    resources :game_users
  end
  post '/join_game/:id', to: 'game_users#create', as: '/join_game'
  post '/login', to: 'session#create'
  delete '/logout', to: 'session#delete'
  mount ActionCable.server, at: '/cable'
end
