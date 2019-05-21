class PokemonsController < ApplicationController
  before_action :set_pokemon, only: %i[show edit update destroy]
  before_action :set_user, only: %i[new create update]
  skip_before_action :authenticate_user!, only: %i[index search]

  def index
    @pokemons = Pokemon.all
    render :home
  end

  def show
  end

  def new
    @pokemon = Pokemon.new
  end

  def create
    @pokemon = Pokemon.new(params_pokemon)
    @pokemon.professor_id = @user.id
    if @pokemon.save!
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @pokemon.update(params_pokemon)
    redirect_to user_path(@user)
  end

  def destroy
    @pokemon.destroy
    redirect_to user_path(current_user)
  end

  def search

  end

  private

  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def params_pokemon
    params.require(:pokemon).permit(:name, :poke_type, :anime_url, :image_url, :level)
  end
end
