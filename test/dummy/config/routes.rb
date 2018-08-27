Rails.application.routes.draw do
  mount Components::Engine => '/components'
end
