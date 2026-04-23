class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :retweets, dependent: :destroy
  # Why: removing a tweet should also remove its discussion thread.
  has_many :comments, dependent: :destroy

  validates :content, presence: true, length: { maximum: 255 },
            format: { without: /\A\s+\z/, message: "can't contain only blanks" }

  def as_json(options = {})
    # Why: feed UI needs interaction metadata in one response to avoid N+1 client requests.
    super(options.merge(include: {
      user: { only: [:username] },
      likes: { only: [:user_id] },
      retweets: { only: [:user_id] },
      comments: { include: { user: { only: [:username] } }, only: [:id, :content, :user_id, :created_at] }
    }))
  end
end
