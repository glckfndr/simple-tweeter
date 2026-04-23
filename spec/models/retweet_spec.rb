require 'rails_helper'

RSpec.describe Retweet, type: :model do
  let(:user) { create(:user) }
  let(:tweet) { create(:tweet) }
  let(:retweet) { build(:retweet, user: user, tweet: tweet) }

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
    it 'validates uniqueness of user_id scoped to tweet_id' do
      user = create(:user)
      tweet = create(:tweet)
      create(:retweet, user: user, tweet: tweet)
      duplicate_retweet = build(:retweet, user: user, tweet: tweet)

      expect(duplicate_retweet).not_to be_valid
      expect(duplicate_retweet.errors[:user_id]).to include('has already been taken')
    end
  end

  describe 'creating a retweet' do
    it 'is valid with valid attributes' do
      expect(retweet).to be_valid
    end

    it 'is not valid without a user' do
      retweet.user = nil
      expect(retweet).not_to be_valid
    end

    it 'is not valid without a tweet' do
      retweet.tweet = nil
      expect(retweet).not_to be_valid
    end

    it 'is not valid if the user has already retweeted the same tweet' do
      create(:retweet, user: user, tweet: tweet)
      expect(retweet).not_to be_valid
    end
  end
end
