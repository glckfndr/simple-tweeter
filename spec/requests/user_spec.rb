require 'rails_helper'

RSpec.describe "Users", type: :request do
  include Devise::Test::IntegrationHelpers

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

    it "returns the correct user data" do
      get user_path(other_user)
      json_response = JSON.parse(response.body)
      expect(json_response["username"]).to eq(other_user.username)
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
  end

  describe "GET /users/:id/followees" do
    it "returns a success response" do
      get followees_user_path(user)
      expect(response).to be_successful
    end

    it "returns the correct followees data" do
      user.followees << other_user
      get followees_user_path(user)
      json_response = JSON.parse(response.body)
      expect(json_response["followees"].first["username"]).to eq(other_user.username)
    end
  end
end
