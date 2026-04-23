require 'rails_helper'

RSpec.describe "Comments", type: :request do
  include Devise::Test::IntegrationHelpers

  # Why: comments belong to a tweet thread, so tests use another author's tweet as baseline.
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:tweet) { create(:tweet, user: other_user) }

  before do
    sign_in user
  end

  describe "POST /tweets/:tweet_id/comments" do
    it "creates a comment" do
      expect {
        post tweet_comments_path(tweet), params: { comment: { content: 'Nice tweet!' } }, headers: { 'ACCEPT' => 'application/json' }
      }.to change(Comment, :count).by(1)

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response['content']).to eq('Nice tweet!')
      expect(json_response['user_id']).to eq(user.id)
    end

    it "returns unprocessable_entity for invalid comment" do
      post tweet_comments_path(tweet), params: { comment: { content: '' } }, headers: { 'ACCEPT' => 'application/json' }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /tweets/:tweet_id/comments/:id" do
    let!(:comment) { create(:comment, tweet: tweet, user: user) }

    it "deletes own comment" do
      expect {
        delete tweet_comment_path(tweet, comment), headers: { 'ACCEPT' => 'application/json' }
      }.to change(Comment, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "forbids deleting someone else's comment" do
      foreign_comment = create(:comment, tweet: tweet, user: other_user)
      delete tweet_comment_path(tweet, foreign_comment), headers: { 'ACCEPT' => 'application/json' }

      expect(response).to have_http_status(:forbidden)
    end
  end
end
