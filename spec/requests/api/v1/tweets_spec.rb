require 'rails_helper'

RSpec.describe "Api::V1::Tweets", type: :request do
  let(:user) { create(:user) }
    let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
    let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:tweet_params) { { tweet: { content: 'This is a test tweet' } } }

  describe 'POST /api/v1/tweets' do
    context 'with valid attributes' do
      it 'creates a new tweet' do
        expect {
          post '/api/v1/tweets/create', params: tweet_params, headers: headers, as: :json
        }.to change(Tweet, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['content']).to eq('This is a test tweet')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new tweet' do
        invalid_params = { tweet: { content: '' } }
        expect {
          post '/api/v1/tweets/create', params: invalid_params, headers: headers, as: :json
        }.not_to change(Tweet, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('errors')
      end
    end
  end

  describe 'GET /api/v1/tweets/:id' do
    let(:tweet) { create(:tweet, user: user) }

    it 'returns the tweet' do
      get "/api/v1/show/#{tweet.id}", headers: headers, as: :json
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['content']).to eq(tweet.content)
    end
  end

  describe 'DELETE /api/v1/tweets/:id' do
    let!(:tweet) { create(:tweet, user: user) }

    it 'deletes the tweet' do
      expect {
        delete "/api/v1/destroy/#{tweet.id}", headers: headers, as: :json
      }.to change(Tweet, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'returns an error if the tweet does not belong to the user' do
      other_user = create(:user)
      other_tweet = create(:tweet, user: other_user)
      delete "/api/v1/destroy/#{other_tweet.id}", headers: headers, as: :json

      #expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to include('errors')
    end
  end

  describe "with authentication" do
      it 'returns tweets with authorization token' do
        create_list(:tweet, 10, user: user)
        get '/api/v1/tweets/index', headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(10)
      end

      it 'returns unauthorized without authorization token' do
        get '/api/v1/tweets/index'
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include('errors')
      end
    end
end
