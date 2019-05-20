class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :battle, foreign_key: true
      t.text :comment
      t.integer :rating

      t.timestamps
    end
  end
end
