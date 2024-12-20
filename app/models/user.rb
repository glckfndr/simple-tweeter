class User < ApplicationRecord
  has_many :tweets, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self # include devise-jwt
  validates :username, presence: true, length: { minimum: 3 }, uniqueness: true
  validates :email, uniqueness: true
  validate :validate_email
  validate :validate_password, if: -> { new_record? || !password.nil? }

  def self.jwt_revoked?(decoded_token, user)
    return false if user.last_logout_at.nil?

    issued_at = Time.at(decoded_token['iat']).utc
    revoked = issued_at < user.last_logout_at

    revoked
  end

  def self.revoke_jwt(decoded_token, user)
    user.update(last_logout_at: Time.current)
  end

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
