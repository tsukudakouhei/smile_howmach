Rails.application.routes.draw do
  root 'tops#index'
  get 'terms_of_use', to: "tops#terms_of_use"
  get 'privacy_policy', to: "tops#privacy_policy"
  
  resources :users, only: %i(new create)
  resources :smile_prices
  get 'login', to: 'user_sessions#new'
  post 'login', to: "user_sessions#create"
  delete 'logout', to: 'user_sessions#destroy'
end
