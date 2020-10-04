Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help' => 'static_pages#help'
  get '/about' => 'static_pages#about'
  get '/contact' => 'static_pages#contact'
  get '/signup' => 'users#new'
  post '/signup' => 'users#create'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
  get '/search' => 'microposts#index'
  get '/ranking' => 'microposts#show_ranking'
  get '/graph' => 'users#graph'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new,:create,:edit,:update]
  resources :microposts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
