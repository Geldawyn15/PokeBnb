class Transfer < ApplicationRecord
  belongs_to :trainer, class_name: "User"
  belongs_to :pokemon
  validates :date, :trainer_id, :pokemon_id, presence: true
  accepts_nested_attributes_for :reviews
end
