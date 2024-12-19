require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    context 'positive tests' do
      it 'is authenticated with valid credentionlas' do
        user = build(:user)
        expect(user).to be_valid
      end

      it 'is valid when a password contains any characters repeat up to twice' do
        user = build(:user, password: "22334455##")
        expect(user).to be_valid
      end

      it 'is valid when a password contains at least one symbol' do
        user = build(:user, password: "@#≈™]€*([@")
        expect(user).to be_valid
      end

      describe 'associations' do
        it 'should have many tweets' do
          association = described_class.reflect_on_association(:tweets)
          expect(association.macro).to eq :has_many
        end
      end
    end

    context 'negative tests' do
      describe 'username' do
        it 'is invalid when nil' do
          user = build(:user, username: nil)
          expect(user).not_to be_valid
        end

        it 'is invalid when empty' do
          user = build(:user, username: '')
          expect(user).not_to be_valid
        end

        it 'is invalid when it is short (<3)' do
          user = build(:user, username: 'ra')
          expect(user).not_to be_valid
        end
      end

      it 'is invalid when the user with the same username is already in db' do
        create(:user, username: "gal")
        user = build(:user, username: "gal")
        expect(user).not_to be_valid
      end

      describe 'email' do
        it 'is when email is nil' do
          user = build(:user, email: nil)
          expect(user).not_to be_valid
        end

        it 'is invalid when the same email exists' do
          create(:user, email: 'user@test.com')
          user = build(:user, email: 'user@test.com')
          expect(user).not_to be_valid
        end

        it 'is invalid when it is improperly formatted' do
          improper_email = ['abcdef', 'abcdef@', 'abcdef@.', 'abcdef@com','abcdef@.com','abcdef@com.', '@abcdef.com']
          improper_email.each do |email|
            user = build(:user, email: email)
            expect(user).not_to be_valid, "#{email.inspect} should be invalid"
          end
        end
      end

      describe 'password' do
        it 'is invalid without password' do
          user = build(:user, password: nil)
          expect(user).not_to be_valid
        end

        it 'is invalid when it contains less then 8 characters' do
          user = build(:user, password: '@#≈™]€*')
          expect(user).not_to be_valid
        end

        it 'is invalid when contains any characters repeat more than twice' do
          user = build(:user, password: "22234455##")
          expect(user).not_to be_valid
        end

        it 'is invalid when does not contain at least one symbol' do
          user = build(:user, password: "jl4ksDfojwkx2t5")
          expect(user).not_to be_valid
        end

      end
    end

  end

  describe 'Token revocation' do
    let(:user) { create(:user) }
    let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
    let(:decoded_token) { Warden::JWTAuth::TokenDecoder.new.call(token) }

    describe '.jwt_revoked?' do
      context 'when the user has not logged out' do
        it 'returns false' do
          expect(User.jwt_revoked?(decoded_token, user)).to be_falsey
        end
      end

      context 'when the user has logged out' do
        before do
          user.update(last_logout_at: Time.current - 1.hour)
        end

        it 'returns true if the token was issued before the last logout' do
          expect(User.jwt_revoked?(decoded_token, user)).to be_truthy
        end

        it 'returns false if the token was issued after the last logout' do
          new_token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
          new_decoded_token = Warden::JWTAuth::TokenDecoder.new.call(new_token)
          expect(User.jwt_revoked?(new_decoded_token, user)).to be_falsey
        end
      end

      context 'when the user has no last_logout_at timestamp' do
        before do
          user.update(last_logout_at: nil)
        end

        it 'returns false' do
          expect(User.jwt_revoked?(decoded_token, user)).to be_falsey
        end
      end
    end

    describe '.revoke_jwt' do
      it 'updates the last_logout_at timestamp' do
        expect { User.revoke_jwt(decoded_token, user) }.to change { user.reload.last_logout_at }
      end
    end
  end

end
