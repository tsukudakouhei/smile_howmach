Rails.application.routes.draw do
  root 'smile_prices#index'
  get 'about', to: "tops#index"
  get 'terms_of_use', to: "tops#terms_of_use"
  get 'privacy_policy', to: "tops#privacy_policy"
  
  resources :users, only: %i(new create show)
  resources :smile_prices
  get 'login', to: 'user_sessions#new'
  post 'login', to: "user_sessions#create"
  delete 'logout', to: 'user_sessions#destroy'
  post '/guest_login', to: 'user_sessions#guest_login'
end
