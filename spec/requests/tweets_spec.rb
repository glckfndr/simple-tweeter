require 'rails_helper'

RSpec.describe TweetsController, type: :controller do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:tweet) { create(:tweet, user: user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
      expect(assigns(:tweets)).not_to be_nil
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Tweet" do
        expect {
          post :create, params: { tweet: { content: 'New tweet content' } }
        }.to change(Tweet, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid params" do
      it "returns an unprocessable entity response" do
        post :create, params: { tweet: { content: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end


  describe "PATCH #update" do
    context "with valid params" do
      it "updates the requested tweet" do
        patch :update, params: { id: tweet.to_param, tweet: { content: 'Updated content' } }
        tweet.reload
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "returns an unprocessable entity response" do
        patch :update, params: { id: tweet.to_param, tweet: { content: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when tweet does not exist" do
      it "returns not found" do
        patch :update, params: { id: 0, tweet: { content: 'Updated content' } }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested tweet" do
      tweet
      expect {
        delete :destroy, params: { id: tweet.to_param }
      }.to change(Tweet, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it "returns not found when tweet does not exist" do
      delete :destroy, params: { id: 0 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #like" do
    let(:other_user) { create(:user) }
    let(:other_tweet) { create(:tweet, user: other_user) }

    it "likes another user's tweet" do
      post :like, params: { id: other_tweet.to_param }
      expect(response).to have_http_status(:ok)
      expect(other_tweet.likes.where(user: user).count).to eq(1)
    end

    it "does not allow liking own tweet" do
      post :like, params: { id: tweet.to_param }
      expect(response).to have_http_status(:forbidden)
    end

    it "is idempotent when liking the same tweet twice" do
      post :like, params: { id: other_tweet.to_param }
      post :like, params: { id: other_tweet.to_param }

      expect(response).to have_http_status(:ok)
      expect(other_tweet.likes.where(user: user).count).to eq(1)
    end
  end

  describe "DELETE #unlike" do
    let(:other_user) { create(:user) }
    let(:other_tweet) { create(:tweet, user: other_user) }

    it "removes an existing like" do
      other_tweet.likes.create!(user: user)

      expect {
        delete :unlike, params: { id: other_tweet.to_param }
      }.to change { other_tweet.likes.where(user: user).count }.from(1).to(0)

      expect(response).to have_http_status(:ok)
    end

    it "is idempotent when like does not exist" do
      delete :unlike, params: { id: other_tweet.to_param }
      expect(response).to have_http_status(:ok)
      expect(other_tweet.likes.where(user: user).count).to eq(0)
    end
  end

  describe "POST #retweet" do
    it "retweets the tweet" do
      post :retweet, params: { id: tweet.to_param }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #unretweet" do
    it "unretweets the tweet" do
      post :unretweet, params: { id: tweet.to_param }
      expect(response).to have_http_status(:ok)
    end
  end
end
