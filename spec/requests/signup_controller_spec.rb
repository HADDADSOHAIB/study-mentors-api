require 'rails_helper'
RSpec.describe Api::V1::SignupController do
  let(:student) { build(:student) }

  describe 'POST /api/v1/login' do
    before do
      post '/api/v1/signup', params:
        {
          account_type: 'Student',
          user:
            {
              fullname: 'user_test',
              email: 'user_student@example.com',
              password: 'password'

            }
        }
    end
    it 'returns http created' do
      expect(response).to have_http_status(:created)
    end
    it 'JSON body response contains expected elements' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(%w[csrf access current_user categories])
    end
  end

  describe 'POST /api/v1/login with duplicated email' do
    before do
      student.save
      post '/api/v1/signup', params:
        { account_type: 'Student',
          user: {
            fullname: 'user_test',
            email: 'user_student@example.com',
            password: 'password'
          } }
    end
    it 'returns http created' do
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST /api/v1/signup/unique with a valid email' do
    before do
      post '/api/v1/signup/unique', params: { email: 'user_student@example.com' }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'JSON body response contains expected elements' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(['email'])
    end
    it 'it should return email: true' do
      json_response = JSON.parse(response.body)
      expect(json_response['email']).to be(true)
    end
  end

  describe 'POST /api/v1/signup/unique with a dublicated email' do
    before do
      student.save
      post '/api/v1/signup/unique', params: { email: 'user_student@example.com' }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'JSON body response contains expected elements' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(['email'])
    end
    it 'it should return email: false' do
      json_response = JSON.parse(response.body)
      expect(json_response['email']).to be(false)
    end
  end
end
