Rails.application.routes.draw do
  devise_for :users

  resources :portfolios
  resources :stocks, except: [:index, :show]

  get "search", to: "stocks#search"
  get "result", to: "stocks#result"

  get "users/:id/dashboard", to: "user#dashboard", as: "dashboard"

  # root to: "pages#home"

  root to: "stocks#search"
end
