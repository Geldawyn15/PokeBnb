class Pokemon < ApplicationRecord
  type_array = [
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
  belongs_to :professor, class_name: "User", foreign_key: "professor_id"
  has_many :battles
  validates :name, :professor_id, :level, presence: true
  validates :type, inclusion: { in: type_array, message: '%{value} is not a valid category' }


end
