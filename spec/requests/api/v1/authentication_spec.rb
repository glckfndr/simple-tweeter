require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let(:user) { create(:user) }

  describe 'POST /api/v1/users/sign_in' do
    it 'authenticates the user and returns a JWT' do
      post '/api/v1/users/sign_in', params: { user: { email: user.email, password: user.password } }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('token')
    end

    it 'returns an error when email is missing' do
      post '/api/v1/users/sign_in', params: { user: { email: nil, password: user.password } }
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to include('error')
    end

    it 'returns an error when password is missing' do
      post '/api/v1/users/sign_in', params: { user: { email: user.email, password: nil } }
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to include('error')
    end

    it 'returns an error when password is incorrect' do
      post '/api/v1/users/sign_in', params: { user: { email: user.email, password:  user.password + '1'} }
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to include('error')
    end
  end
end
