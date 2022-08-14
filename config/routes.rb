Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users
  resources :users, only: [:index, :edit, :update]
  resources :courses
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'activity', to: 'home#activity'
end
