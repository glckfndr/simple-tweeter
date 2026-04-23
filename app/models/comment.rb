class Comment < ApplicationRecord
  belongs_to :tweet
  belongs_to :user

  # Why: short limit keeps comment payloads fast for timeline rendering.
  validates :content, presence: true, length: { maximum: 255 }
end
