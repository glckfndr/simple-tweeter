class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true
  has_many :tweets, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :follower_relationships, foreign_key: :followee_id, class_name: 'Follow', dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :followee_relationships, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy
  has_many :followees, through: :followee_relationships, source: :followee

  has_many :retweets, dependent: :destroy
end
