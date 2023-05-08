Rails.application.routes.draw do
  root 'top#index'
  resources :users, only: %i(new create show)
  resources :smile_prices
  get 'login', to: 'user_sessions#new'
  post 'login', to: "user_sessions#create"
  delete 'logout', to: 'user_sessions#destroy'
end
