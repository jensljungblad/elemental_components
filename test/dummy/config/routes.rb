Rails.application.routes.draw do
  mount Components::Engine => "/styleguide"

  resources :comments, only: :index
  resources :users, only: :show
end
