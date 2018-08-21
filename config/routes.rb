Components::Engine.routes.draw do
  get '*path', to: 'pages#show', as: :page
end
