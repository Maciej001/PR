Rails.application.routes.draw do
  devise_for 	:users
  resources 	:users

  root to: "application#index"

  get "application/admin", to: "application#admin"
end
