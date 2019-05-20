class Pokemon < ApplicationRecord
  belongs_to :professor, class_name: "User", foreign_key: "professor_id"
  has_many :battles
  validates :name, :professor_id, :type, :level, presence: true


end
