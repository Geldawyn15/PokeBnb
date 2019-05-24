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
    nidoran
    @pokemon.professor_id = @user.id
    @pokemon.poke_type = api_pokemon_type
    @pokemon.save!
    @pokemon.image_url = api_pokemon_image
    @pokemon.ability1 = api_pokemon_ability1
    @pokemon.ability2 = api_pokemon_ability2
    @pokemon.defense = api_pokemon_defense
    @pokemon.attack = api_pokemon_attack
    @pokemon.hp = api_pokemon_hp
    @pokemon.height = api_pokemon_height
    @pokemon.weight = api_pokemon_weight
    @pokemon.anime_url = "http://pokestadium.com/sprites/xy/#{nidoran_sprite(nidoran)}.gif"
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
      query << "name ILIKE '\%#{@search['name']}\%'" if @search["name"] != ''
      query << "poke_type ILIKE '\%#{@search['type'].downcase.capitalize}\%'" if @search["type"] != ''
      query << "level = '#{@search['level']}'" if @search["level"] != ''
      query = query.join(",")
      @pokemons = Pokemon.where(query)
      @pokemons = @pokemons.joins(:transfers).where("transfers.date = ?", @search['date']) if @search["date"] != ''
    else
      @pokemons = Pokemon.all
    end
  end

  private

  # SET USER AND POKEMON METHODS

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

  # STRONG PARAMS

  def params_pokemon
    params.require(:pokemon).permit(:name, :poke_type, :anime_url, :image_url, :level, :search)
  end

  # API POKEMON

  def api_pokemon
    name = nidoran
    url = "https://pokeapi.co/api/v2/pokemon/#{name}"
    p url
    html_content = open(url).read
    JSON.parse(html_content)
  end

  def api_pokemon_image
    name = nidoran

    url_img = "https://www.pokemon.com/us/pokedex/#{name}"
    page = open(url_img).read
    noko = Nokogiri::HTML.parse(page)
    noko.search(".profile-images img").attribute('src').value
  end

  def api_pokemon_type
    api_pokemon['types'][0]['type']['name'].downcase.capitalize
  end

  def api_pokemon_ability1
    api_pokemon["abilities"][0]["ability"]["name"]
  end

  def api_pokemon_ability2
    if api_pokemon["abilities"][1]
      api_pokemon["abilities"][1]["ability"]["name"]
    else
      "none"
    end
  end

  def api_pokemon_hp
    api_pokemon["stats"][5]["base_stat"]
  end

  def api_pokemon_defense
    api_pokemon["stats"][3]["base_stat"]
  end

  def api_pokemon_attack
    api_pokemon["stats"][4]["base_stat"]
  end

  def api_pokemon_height
    api_pokemon["height"]
  end

  def api_pokemon_weight
    api_pokemon["weight"]
  end

  # NIDORAN SPECIAL CASE

  def nidoran
    if params[:pokemon][:name].downcase == "nidoran"
      nido = [29, 32]
      nido.sample
    else
      params[:pokemon][:name].downcase
    end
  end

  def nidoran_sprite(nidoran)
    if nidoran == 29
      "nidoranf"
    elsif nidoran == 32
      "nidoranm"
    else
      params[:pokemon][:name].downcase
    end
  end
end
