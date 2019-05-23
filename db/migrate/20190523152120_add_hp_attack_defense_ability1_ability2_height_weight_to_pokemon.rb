class AddHpAttackDefenseAbility1Ability2HeightWeightToPokemon < ActiveRecord::Migration[5.2]
  def change
    add_column :pokemons, :hp, :integer
    add_column :pokemons, :attack, :integer
    add_column :pokemons, :defense, :integer
    add_column :pokemons, :ability1, :string
    add_column :pokemons, :ability2, :string
    add_column :pokemons, :height, :integer
    add_column :pokemons, :weight, :integer
  end
end
