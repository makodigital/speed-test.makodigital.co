Rails.application.routes.draw do
  root to: 'speed_tests#new'

  resources :speed_tests
end
