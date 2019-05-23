class TransfersController < ApplicationController
  before_action :set_transfer, only: %i[update destroy]
  before_action :set_pokemon, only: %i[create]

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

  def update
    @transfer.update(params_transfer)
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
    @pokemon = Pokemon.find(params[:pokemon_id])
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
end


def cocktail_params
    params.require(:cocktail)
          .permit(:name,
                  )
  end
