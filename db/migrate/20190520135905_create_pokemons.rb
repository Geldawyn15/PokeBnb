class CreatePokemons < ActiveRecord::Migration[5.2]
  def change
    create_table :pokemons do |t|
      t.string :name, null: false
      t.string :poke_type, null: false
      t.string :image_url
      t.string :anime_url
      t.integer :level, null: false
      t.references :professor, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
