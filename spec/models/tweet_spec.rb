require 'rails_helper'

RSpec.describe Tweet, type: :model do
  it 'is valid with valid attributes' do
    user = create(:user)
    tweet = Tweet.new(content: 'This is a valid tweet', user: user)
    expect(tweet).to be_valid
  end

  it 'is not valid without content' do
    user = create(:user)
    tweet = Tweet.new(content: nil, user: user)
    expect(tweet).not_to be_valid
  end

  it 'is not valid with content longer than 255 characters' do
    user = create(:user)
    long_content = 'a' * 256
    tweet = Tweet.new(content: long_content, user: user)
    expect(tweet).not_to be_valid
  end
end
