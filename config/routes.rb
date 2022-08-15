Rails.application.routes.draw do
  resources :enrollments
  devise_for :users

  root to: 'home#index'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'activity', to: 'home#activity'

  resources :users, only: [:index, :edit, :update, :show]
  resources :courses do
    resources :enrollments, only: [:new, :create]
    resources :lessons
  end
end
