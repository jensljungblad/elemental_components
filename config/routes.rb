Components::Engine.routes.draw do
  root to: 'pages#show'
  get '*path', to: 'pages#show', as: :page
end
