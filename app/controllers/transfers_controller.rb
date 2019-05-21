class TransfersController < ApplicationController
  before_action :set_transfer, only: %i[update destroy]
  before_action :set_pokemon, only: %i[create]

  def create
    @transfer = Transfer.new(params_transfer)
    @transfer.trainer_id = current_user
    @transfer.pokemon_id = @pokemon
    if @pokemon.save!
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def update
    respond_to do |format|
      if @transfer.update(params_pokemon)
        format.html { redirect_to user_path(current_user), notice: 'Transfer was successfully updated.' }
        format.json { render :show, status: :ok, location: @transfer }
      else
        format.html { render :edit }
        format.json { render json: @transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @pokemon.destroy
    redirect_to user_path(current_user)
  end

  def set_transfer
    @transfer = Transfer.find(params[:id])
  end

  def set_pokemon
    @pokemon = Pokemon.find(params[:pokemon_id])
  end

  def params_transfer
    params.require(:pokemon).permit(:date)
  end
end
