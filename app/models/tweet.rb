class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy

  validates :content, presence: true, length: { maximum: 255 }

  def as_json(options = {})
    super(options.merge(include: { user: { only: [:username] } }))
  end
end
