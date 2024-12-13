class Tweet < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 255 }

  validate :validate_blank

  private

  def validate_blank
    if content.blank? || content.match(/^\s+$/)
      errors.add(:content, "can't be blank or contain only blanks")
    end
  end
end
