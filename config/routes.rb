Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'activity', to: 'home#activity'

  resources :users, only: [:index, :edit, :update, :show]
  resources :courses
  resources :lessons
end
