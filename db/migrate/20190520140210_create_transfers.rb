class CreateTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :transfers do |t|
      t.date :date, null: false
      t.references :trainer, index: true, foreign_key: { to_table: :users }, null: false
      t.references :pokemon, foreign_key: true, null: false
      t.string :enemy_name
      t.string :enemy_type
      t.integer :enemy_level
      t.string :outcome

      t.timestamps
    end
  end
end
