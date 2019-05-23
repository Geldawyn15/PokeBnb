Rails.application.routes.draw do
  devise_for :users

  root to: 'pokemons#index', as: 'home'
  resources :users, only: %i[show] do
    resources :pokemons, only: %i[new create update]
  end

  resources :pokemons, only: %i[index show edit update destroy]  do
    collection do
      get :search
    end
    resources :transfers, only: %i[create]
  end
<<<<<<< HEAD
  resources :transfers, only: %i[new update destroy] do
    resources :reviews, only: %i[new create]
  end

=======
  resources :transfers, only: %i[edit update destroy]
>>>>>>> master
end
