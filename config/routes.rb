Rails.application.routes.draw do
  devise_for :users
  root to: 'pokemons#index'
  resources :pokemons, only: %i[show new create edit update delete]  do
    get :search
  end
  resources :users, only: %i[show new create edit update]
  resources :transfers, only: %[index new create edit update]
  resources :reviews, only: %[index new create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
