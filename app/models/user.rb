class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tweets, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :follower_relationships, foreign_key: :followee_id, class_name: 'Follow', dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :followee_relationships, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy
  has_many :followees, through: :followee_relationships, source: :followee

  has_many :retweets, dependent: :destroy

  validates :username, presence: true, length: { minimum: 3 }, uniqueness: true
  validates :email, uniqueness: true
  validate :validate_email
  validate :validate_password, if: -> { new_record? || !password.nil? }

  private

  def validate_email
    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    unless email =~ email_regex
      errors.add(:email, "must be a valid email address")
    end
  end


  def validate_password
    return if password.blank?
    if password.length < 8
      errors.add(:password, "is too short (minimum is 8 characters)")
    end

    if password.scan(/\W/).empty?
      errors.add(:password, "must contain at least one symbol")
    end

    if password =~ /(.)\1\1/
      errors.add :password, 'cannot have any characters repeated more than twice'
    end
  end
end
