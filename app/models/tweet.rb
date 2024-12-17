class Tweet < ApplicationRecord
  belongs_to :user

  validates :content, presence: true,
      length: { maximum: 255 },
      format: { without: /\A\s+\z/, message: "can't contain only blanks" }

end
