Components::Engine.routes.draw do
  get '*path', to: 'pages#show'
end
