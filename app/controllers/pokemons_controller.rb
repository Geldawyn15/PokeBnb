require 'open-uri'

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
    @pokemon.poke_type = api_pokemon_type
    @pokemon.image_url = api_pokemon_image
    name = nidoran
    if name.class == Integer
      if name == 29
        name = "nidoranf"
      elsif name == 32
        name = "nidoranm"
      end
    end
    @pokemon.anime_url = "http://pokestadium.com/sprites/xy/#{name}.gif"
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
    if params[:user_id]
      @user = User.find(params[:user_id])
    elsif @pokemon
      @user = User.find(@pokemon.professor_id)
    end
  end

  def params_pokemon
    params.require(:pokemon).permit(:name, :poke_type, :anime_url, :image_url, :level, :search)
  end

  def api_pokemon_type
    name = nidoran
    p url = "https://pokeapi.co/api/v2/pokemon/#{name}"
    html_content = open(url).read
    doc = JSON.parse(html_content)
    doc['types'][0]['type']['name'].downcase.capitalize
  end

  def api_pokemon_image
    name = nidoran
    if name.class == Integer
      if name == 29
        name = "nidoran-female"
      elsif name == 32
        name = "nidoran-male"
      end
    end
    p url_img = "https://www.pokemon.com/us/pokedex/#{name}"
    page = open(url_img).read
    noko = Nokogiri::HTML.parse(page)
    noko.search(".profile-images img").attribute('src').value
  end

  def nidoran
    if params[:pokemon][:name].downcase == "nidoran"
      nido = [29, 32]
      name = nido.sample
    else
      name = params[:pokemon][:name].downcase
    end
    return name
  end
end
