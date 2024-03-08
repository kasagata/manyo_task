Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  resources :labels
  resources :users
  namespace :admin do
    resources :users
  end
  resources :sessions, only: [:new, :create, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
