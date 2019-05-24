Rails.application.routes.draw do
  devise_for :users

  root to: 'pokemons#index', as: 'home'
  resources :users, only: %i[show update] do
    resources :pokemons, only: %i[new create update]
  end

  resources :pokemons, only: %i[index show edit update destroy]  do
    collection do
      get :search
    end
    resources :transfers, only: %i[create]
  end
  resources :transfers, only: %i[edit update destroy]
end
