require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:follower) { create(:user) }
  let(:followee) { create(:user) }
  subject { create(:follow, follower: follower, followee: followee) }

  describe 'associations' do
    it 'belongs to follower' do
      association = described_class.reflect_on_association(:follower)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to followee' do
      association = described_class.reflect_on_association(:followee)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'validations' do

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a follower' do
      subject.follower = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a followee' do
      subject.followee = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'custom methods' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:follow) { create(:follow, follower: user1, followee: user2) }

    it 'returns the correct follower' do
      expect(follow.follower).to eq(user1)
    end

    it 'returns the correct followee' do
      expect(follow.followee).to eq(user2)
    end
  end
end
