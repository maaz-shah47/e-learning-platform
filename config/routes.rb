Rails.application.routes.draw do
  resources :enrollments do
    get 'my_students', on: :collection
  end
  devise_for :users

  root to: 'home#index'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'activity', to: 'home#activity'

  resources :users, only: %i[index edit update show]
  resources :courses do
    get 'purchased', 'pending_review', 'created', on: :collection
    resources :enrollments, only: %i[new create]
    resources :lessons
  end
end
