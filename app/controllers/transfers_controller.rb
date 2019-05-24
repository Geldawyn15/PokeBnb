class TransfersController < ApplicationController
  before_action :set_transfer, only: %i[edit update destroy]
  before_action :set_pokemon, only: %i[create edit]

  def create
    @transfer = Transfer.new(params_transfer)
    @transfer.trainer_id = current_user
    @transfer.pokemon_id = @pokemon.id
    if @transfer.save!
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @transfer.update(params_transfer)
    @transfer.enemy_type = api_pokemon_type(@transfer.enemy_name)
    if @transfer.outcome.downcase.include?("y") || @transfer.outcome.downcase.include?("w")
      @transfer.outcome = "win"
    elsif @transfer.outcome.downcase.include?("n") || @transfer.outcome.downcase.include?("l")
      @transfer.outcome = "lose"
    else
      @transfer.outcome = nil
    end
    @transfer.save
    redirect_to user_path(current_user)
  end

  def destroy
    @transfer.destroy
    redirect_to user_path(current_user)
  end

  def set_transfer
    @transfer = Transfer.find(params[:id])
  end

  def set_pokemon
    if params[:pokemon_id]
      @pokemon = Pokemon.find(params[:pokemon_id])
    elsif @transfer
      @pokemon = Pokemon.find(@transfer.pokemon_id)
    end
  end

  def params_transfer
    params.require(:transfer).permit(:date,
                                     :enemy_name,
                                     :enemy_type,
                                     :enemy_level,
                                     :outcome,
                                     :comment,
                                     :rating)
  end

  def api_pokemon_type(pokemon_name)
    p url = "https://pokeapi.co/api/v2/pokemon/#{pokemon_name.downcase}"
    html_content = open(url).read
    doc = JSON.parse(html_content)
    doc['types'][0]['type']['name'].downcase.capitalize
  end
end










