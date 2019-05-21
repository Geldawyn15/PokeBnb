Rails.application.routes.draw do
  get 'users/new'
  devise_for :users
  root to: 'pages#home'
  resources :pokemons, only: %i[show new create edit update delete]  do
    get :search
  end
  resources :transfers, only: %[index new create edit update]
  resources :reviews, only: %[index new create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
