require 'rails_helper'

RSpec.describe Api::V1::StudentsController do
  let(:student) { build(:student) }

  describe 'PUT /students/:id/update_profil' do
    before do
      student.save
      post '/api/v1/login', params:
        {
          :login => {
            account_type: 'Student',
            email: 'user_student@example.com',
            password: 'password'
          }
        }
      json_response = JSON.parse(response.body)
      put "/api/v1/students/#{student.id}/update_profil", params:
      {
        :student => {
          fullname: 'new name',
          phone: 'new phone'
        }
      }, headers:
      {
        Authorization:  "Bearer #{json_response["access"]}"
      }
    end
    it 'returns http ok' do
      expect(response).to have_http_status(:ok)
    end
    it 'JSON body response contains expected elements, current_user' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(%w[current_user])
    end
    it 'the student has the new name' do
      json_response = JSON.parse(response.body)
      expect(json_response["current_user"]["fullname"]).to eq('new name')
    end
    it 'the student has the new phone' do
      json_response = JSON.parse(response.body)
      expect(json_response["current_user"]["phone"]).to eq('new phone')
    end
  end

  describe 'PUT /students/:id/update_profil without a token' do
    before do
      student.save
      put "/api/v1/students/#{student.id}/update_profil", params:
      {
        :student => {
          fullname: 'new name',
          phone: 'new phone'
        }
      }
    end
    it 'returns http unauthorized' do
      expect(response).to have_http_status(:unauthorized)
    end
    it 'JSON body response contains expected elements, error' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(%w[error])
    end
  end

  describe 'PUT /students/:id/update_profil with wrong id' do
    before do
      student.save
      post '/api/v1/login', params:
        {
          :login => {
            account_type: 'Student',
            email: 'user_student@example.com',
            password: 'password'
          }
        }
      json_response = JSON.parse(response.body)
      put "/api/v1/students/#{student.id + 100}/update_profil", params:
      {
        :student => {
          fullname: 'new name',
          phone: 'new phone'
        }
      }, headers:
      {
        Authorization:  "Bearer #{json_response["access"]}"
      }
    end
    it 'returns http 400' do
      expect(response).to have_http_status(400)
    end
    it 'JSON body response contains expected elements, error' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(%w[error])
    end
  end

  describe 'PUT /students/:id/update_profil with wrong params' do
    before do
      student.save
      post '/api/v1/login', params:
        {
          :login => {
            account_type: 'Student',
            email: 'user_student@example.com',
            password: 'password'
          }
        }
      json_response = JSON.parse(response.body)
      put "/api/v1/students/#{student.id + 100}/update_profil", params:
      {
        :student => {
          fullname: '',
          phone: 'new phone'
        }
      }, headers:
      {
        Authorization:  "Bearer #{json_response["access"]}"
      }
    end
    it 'returns http 400' do
      expect(response).to have_http_status(400)
    end
    it 'JSON body response contains expected elements, error' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(%w[error])
    end
  end
end
