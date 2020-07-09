require 'rails_helper'

RSpec.describe Api::V1::LoginController do
  let(:student) { build(:student) }
  describe 'POST /api/v1/login' do
    before do
      student.save
      post '/api/v1/login', params:
        {
          login: {
            account_type: 'Student',
            email: 'user_student@example.com',
            password: 'password'
          }
        }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'JSON body response contains expected elements, csrf, access, current_user, categories' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(%w[csrf access current_user categories])
    end
  end

  describe 'POST /api/v1/login with invalid password' do
    before do
      student.save
      post '/api/v1/login', params:
      {
        login: {
          account_type: 'Student',
          email: 'user_student@example.com',
          password: 'passwordd'
        }
      }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:unauthorized)
    end
    it 'JSON body response contains expected elements, message' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(['message'])
    end
  end

  describe 'POST /api/v1/login with invalid email' do
    before do
      student.save
      post '/api/v1/login', params:
      {
        login: {
          account_type: 'Student',
          email: 'invalid',
          password: 'password'
        }
      }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:unauthorized)
    end
    it 'JSON body response contains expected elements, message' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(['message'])
    end
  end

  describe 'GET /api/v1/login/get_user_by_token' do
    before do
      student.save
      post '/api/v1/login', params:
        {
          login: {
            account_type: 'Student',
            email: 'user_student@example.com',
            password: 'password'
          }
        }
      json_response = JSON.parse(response.body)
      get '/api/v1/login/get_user_by_token', headers: { Authorization: "Bearer #{json_response['access']}" }
    end
    it 'returns http ok' do
      expect(response).to have_http_status(:ok)
    end
    it 'JSON body response contains expected elements, current_user, account_type, categories' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(%w[current_user account_type categories])
    end
  end

  describe 'GET /api/v1/login/get_user_by_token with invalid token' do
    before do
      get '/api/v1/login/get_user_by_token', headers:
        { Authorization: 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NT' }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:unauthorized)
    end
    it 'JSON body response contains expected elements, error' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(['error'])
    end
  end
end
