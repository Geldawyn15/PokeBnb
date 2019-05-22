class User < ApplicationRecord
  has_many :owned_pokemons, class_name: "Pokemon", foreign_key: "professor_id"
  has_many :transfered_pokemons, class_name: "Pokemon"
  has_many :transfers, foreign_key: "trainer_id"
  validates :name, :email, :password, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
