require 'rails_helper'

RSpec.describe 'Registration', type: :request do
  describe 'POST /api/v1/users' do
    let(:user_attr) { attributes_for(:user) }

    it 'registers a new user with valid attributes' do
      post '/api/v1/users', params: {user: user_attr}
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include('id', 'email')
    end

    it 'returns an error when password confirmation does not match' do
      post '/api/v1/users', params: {user: {**user_attr, password_confirmation: user_attr[:password] + '1' }}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to include('errors')
    end

    it 'returns an error when email is missing' do
      post '/api/v1/users', params: {user: {**user_attr, email: nil }}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to include('errors')
    end

    it 'returns an error when password is missing' do
      post '/api/v1/users', params: {user: {**user_attr, password: nil }}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to include('errors')
    end

    it 'returns an error when username is missing' do
      post '/api/v1/users', params: {user: {**user_attr, username: nil }}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('errors')
    end
  end
end
