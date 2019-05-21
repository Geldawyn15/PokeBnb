class Pokemon < ApplicationRecord
  TYPE_ARRAY = [
    'Normal',
    'Fire',
    'Fighting',
    'Water',
    'Flying',
    'Grass',
    'Poison',
    'Electric',
    'Ground',
    'Psychic',
    'Rock',
    'Ice',
    'Bug',
    'Dragon',
    'Ghost',
    'Dark',
    'Steel',
    'Fairy'
  ]
  belongs_to :professor, class_name: "User"
  has_many :transfers
  has_many :reviews, through: :transfers
  validates :name, :professor_id, :level, presence: true
  validates :poke_type, inclusion: { in: TYPE_ARRAY, message: '%{value} is not a valid category' }, presence: true
end
