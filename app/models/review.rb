class Review < ApplicationRecord
  belongs_to :transfer
  validates :rating, :comment, presence: true

end
