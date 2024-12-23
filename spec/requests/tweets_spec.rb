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
  end

  describe "DELETE #destroy" do
    it "destroys the requested tweet" do
      tweet
      expect {
        delete :destroy, params: { id: tweet.to_param }
      }.to change(Tweet, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "POST #like" do
    it "likes the tweet" do
      post :like, params: { id: tweet.to_param }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #unlike" do
    it "unlikes the tweet" do
      post :unlike, params: { id: tweet.to_param }
      expect(response).to have_http_status(:ok)
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
