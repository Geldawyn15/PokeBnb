class AddRatingAndCommentToTransfer < ActiveRecord::Migration[5.2]
  def change
    add_column :transfers, :rating, :integer
    add_column :transfers, :comment, :text
  end
end
