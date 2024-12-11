require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    context 'positive tests' do
      it 'is authenticated with valid credentionlas' do
        user = build(user:)
        expect(user ).to be_valid
      end
    end
    context 'negative tests' do
      it 'is invalid without name' do
        user = build(user:, name: nil)
        expect(user).not_to be_valid
      end

      it 'is invalid without email' do
        user = build(user:, email: nil)
        expect(user).not_to be_valid
      end

      it 'is invalid without password' do
        user = build(user:, password: nil)
        expect(user).not_to be_valid
      end

      it 'is invalid with an empty name' do
        user = build(:user, name: '')
        expect(user).not_to be_valid
      end


      it 'is invalid with the same email' do
        create(:user, email: 'user@test.com')
        user = build(:user, email: 'user@test.com')
        expect(user).not_to be_valid
      end

      it 'is invalid with a short password (<8)' do
        user = build(:user, password: 'Aa#1234')
        expect(user).not_to be_valid
      end

      it 'is invalid with a short name (<3)' do
        user = build(:user, name: 'ra')
        expect(user).not_to be_valid
      end

      it 'is invalid with an improperly formatted email' do
        user = build(:user, email: 'invalid_email')
        expect(user).not_to be_valid
      end

    end

  end
end
