require 'rails_helper'

RSpec.describe "Api::V1::Tweets", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/api/v1/tweets/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/api/v1/tweets/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/api/v1/tweets/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/api/v1/tweets/destroy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "Authentication" do
    let(:user) { create(:user) }
    let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
    let(:headers) { { 'Authorization' => "Bearer #{token}" } }

    describe 'GET /api/v1/tweets' do
      it 'returns tweets for authenticated user' do
        create_list(:tweet, 10, user: user)
        get '/api/v1/tweets', headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(10)
      end

      it 'returns unauthorized without token' do
        get '/api/v1/tweets'
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include('errors')
      end
    end
  end
end
