require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'is not valid without an email' do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end

  it 'is not valid without a password' do
    user = build(:user, password: nil)
    expect(user).not_to be_valid
  end

  it 'is not valid without a username' do
    user = build(:user, username: nil)
    expect(user).not_to be_valid
  end

  it 'is not valid with a duplicate email' do
    create(:user, email: 'user@example.com')
    user = build(:user, email: 'user@example.com')
    expect(user).not_to be_valid
  end

  it 'is not valid with a duplicate username' do
    create(:user, username: 'testuser')
    user = build(:user, username: 'testuser')
    expect(user).not_to be_valid
  end

  it 'has a secure password' do
    user = create(:user, password: 'password')
    expect(user.valid_password?('password')).to be_truthy
    expect(user.valid_password?('wrong_password')).to be_falsey
  end
end
