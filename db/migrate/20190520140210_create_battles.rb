class CreateBattles < ActiveRecord::Migration[5.2]
  def change
    create_table :battles do |t|
      t.integer :date, null: false
      t.references :user, foreign_key: true, null: false
      t.references :pokemon, foreign_key: true, null: false
      t.string :enemy_name
      t.string :enemy_type
      t.integer :enemy_level
      t.string :outcome

      t.timestamps
    end
  end
end
