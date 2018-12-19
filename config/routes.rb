Rails.application.routes.draw do
  devise_for :users

  resources :portfolios
  resources :stocks, except: [:index]

  get "search", to: "stocks#search"
  get "result", to: "stocks#result"

  get "users/:id/dashboard", to: "users#dashboard", as: "dashboard"

  get "pages/home", to: "pages#home", as: "home"
  get "pages/about", to: "pages#about", as: "about"

  root to: "portfolios#index"
end
