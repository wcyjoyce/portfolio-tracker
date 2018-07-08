Rails.application.routes.draw do
  devise_for :users

  get "search", to: "stocks#search"
  get "result", to: "stocks#result"

  # root to: "pages#home"

  root to: "stocks#search"
end
