class CreatePokemons < ActiveRecord::Migration[5.2]
  def change
    create_table :pokemons do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.integer :level, null: false
      t.references :user, foreign_key: 'professor_id'

      t.timestamps
    end
  end
end
