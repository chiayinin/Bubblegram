class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :followingships, foreign_key: :following_id, class_name: "Follow"
  has_many :fans, through: :followingships, source: :fan

  has_many :fanships, foreign_key: :fan_id, class_name: "Follow"
	has_many :followings, through: :fanships, source: :following
end