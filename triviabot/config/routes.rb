Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :players, only: [:index, :show, :create, :update]

  # get 'player'
  resources :questions, only: [:index]
end
