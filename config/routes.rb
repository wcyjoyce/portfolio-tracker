Rails.application.routes.draw do
  devise_for :users

  resources :portfolios
  resources :stocks, except: [:index]

  get "search", to: "stocks#search"
  get "result", to: "stocks#result"

  get "users/:id/dashboard", to: "users#dashboard", as: "dashboard"
  get "users/:id/transactions", to: "users#transactions", as: "transactions"

  root to: "pages#home"
end
