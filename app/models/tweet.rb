class Tweet < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 255 }

  def as_json(options = {})
    super(options.merge(include: { user: { only: [:username] } }))
  end
end
