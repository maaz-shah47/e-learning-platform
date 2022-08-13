Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users
  resources :users
  resources :courses
  get 'privacy_policy', to: 'static_pages#privacy_policy'
end
