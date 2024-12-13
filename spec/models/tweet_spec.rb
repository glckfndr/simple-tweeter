require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe 'validation' do
    context 'positive tests' do
      describe 'content' do
        it 'should not be longer then 255 characters' do
          tweet = build(:tweet)
          expect(tweet).to be_valid
        end
      end

      describe 'assosiations' do
        it 'should belong for a user' do
          assosiation = described_class.reflect_on_assosiation(:user)
          expect(assosiation.macro).to eq :belongs_to
        end
      end
    end

    context 'negative tests' do
      describe 'content' do
        it 'is invalid when it is longer than 255 chars' do
          tweet = build(:tweet, content: "c" * 256)
          expect(tweet).not_to be_valid
        end

        it 'is invalid when it is nil' do
          tweet = build(:tweet, content: nil)
          expect(tweet).not_to be_valid
        end

        it 'is invalid when it contains only blanks' do
          20.times do
            tweet = build(:tweet, content: ' ' * rand(1..255))
            expect(tweet).not_to be_valid
          end
        end
      end
    end

  end
end
