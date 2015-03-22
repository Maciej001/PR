Rails.application.routes.draw do
  devise_for 	:users
  resources 	:users
  
  resources :users do 
  	resources :orders
  end
	resources 	:orders

  resources :users do 
  	resources :trades
  end
  resources :trades

  root to: "application#index"

  get "application/admin", to: "application#admin"
end
