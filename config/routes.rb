Rails.application.routes.draw do
  devise_for 	:users, controllers: {registrations: "users/registrations"}
  resources 	:users
  
  resources :users do 
  	resources :orders
  end
	resources 	:orders
  
  resources :trades
  resources :portfolios

  resources :stats

  root to: "application#index"

  get "application/admin", to: "application#admin"
end
