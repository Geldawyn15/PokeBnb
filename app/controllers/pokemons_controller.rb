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
    @search = params["search"]
    query = []

    if @search.present?
      query << "name= '#{@search['name']}'" if @search["name"] != ''

      query << "poke_type= '#{@search['type'].downcase.capitalize}'" if @search["type"] != ''

      query << "level= '#{@search['level']}'" if @search["level"] != ''

      @pokemons = Pokemon.where(query)

      @pokemons = @pokemons.joins(:transfers).where("transfers.date = ?", @search['date'])if @search["date"] != ''


    else
      @pokemons = Pokemon.all
    end
  end

  private

  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def params_pokemon
    params.require(:pokemon).permit(:name, :poke_type, :anime_url, :image_url, :level, :search)
  end
end
