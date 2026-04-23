require 'rails_helper'

RSpec.describe "Users", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:json_headers) { { "ACCEPT" => "application/json" } }

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /users/:id" do
    it "returns a success response" do
      get user_path(other_user)
      expect(response).to be_successful
    end

    it "returns html for browser navigation" do
      get user_path(other_user)
      expect(response.media_type).to eq("text/html")
    end

    it "returns the correct user data" do
      get user_path(other_user), headers: json_headers
      json_response = JSON.parse(response.body)
      expect(json_response["username"]).to eq(other_user.username)
    end

    it "returns not found for missing user" do
      get user_path(0), headers: json_headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /users/:id/follow" do
    it "follows the user" do
      post follow_user_path(other_user)
      expect(user.followees).to include(other_user)
    end

    it "returns a success response" do
      post follow_user_path(other_user)
      expect(response).to have_http_status(:ok)
    end

    it "does not allow following yourself" do
      post follow_user_path(user)
      expect(response).to have_http_status(:forbidden)
    end

    it "is idempotent when following the same user twice" do
      post follow_user_path(other_user)
      post follow_user_path(other_user)

      expect(response).to have_http_status(:ok)
      expect(user.followee_relationships.where(followee: other_user).count).to eq(1)
    end

    it "returns not found for missing user" do
      post follow_user_path(0)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /users/:id/unfollow" do
    before do
      user.followees << other_user
    end

    it "unfollows the user" do
      delete unfollow_user_path(other_user)
      expect(user.followees).not_to include(other_user)
    end

    it "returns a success response" do
      delete unfollow_user_path(other_user)
      expect(response).to have_http_status(:ok)
    end

    it "does not allow unfollowing yourself" do
      delete unfollow_user_path(user)
      expect(response).to have_http_status(:forbidden)
    end

    it "returns not found for missing user" do
      delete unfollow_user_path(0)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /users/:id/followees" do
    it "returns a success response" do
      get followees_user_path(user)
      expect(response).to be_successful
    end

    it "returns the correct followees data" do
      user.followees << other_user
      get followees_user_path(user), headers: json_headers
      json_response = JSON.parse(response.body)
      expect(json_response["followees"].first["username"]).to eq(other_user.username)
    end

    it "returns not found for missing user" do
      get followees_user_path(0)
      expect(response).to have_http_status(:not_found)
    end
  end
end
