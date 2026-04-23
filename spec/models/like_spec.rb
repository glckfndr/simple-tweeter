require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:tweet) { create(:tweet) }

  describe 'associations' do
    it 'belongs to user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to tweet' do
      association = described_class.reflect_on_association(:tweet)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      like = Like.new(user: user, tweet: tweet)
      expect(like).to be_valid
    end

    it 'is not valid without a user' do
      like = Like.new(user: nil, tweet: tweet)
      expect(like).to_not be_valid
    end

    it 'is not valid without a tweet' do
      like = Like.new(user: user, tweet: nil)
      expect(like).to_not be_valid
    end

    it 'is not valid with a duplicate like for the same tweet by the same user' do
      Like.create(user: user, tweet: tweet)
      duplicate_like = Like.new(user: user, tweet: tweet)
      expect(duplicate_like).to_not be_valid
    end
  end
end
