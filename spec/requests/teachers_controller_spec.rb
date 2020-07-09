require 'rails_helper'
RSpec.describe Api::V1::TeachersController do
  let(:teacher) { build(:teacher) }

  describe 'GET /api/v1/teachers/:id' do
    before do
      teacher.save
      get "/api/v1/teachers/#{teacher.id}"
    end
    it 'returns http ok' do
      expect(response).to have_http_status(:ok)
    end
    it 'JSON body response contains expected elements' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(%w[teacher categories])
    end
    it 'The teacher has the same id' do
      json_response = JSON.parse(response.body)
      expect(json_response["teacher"]["id"]).to eq(teacher.id)
    end
  end

  describe 'GET /api/v1/teachers/:id with wrong id' do
    before do
      teacher.save
      get "/api/v1/teachers/#{teacher.id + 100}"
    end
    it 'returns http 400' do
      expect(response).to have_http_status(400)
    end
    it 'JSON body response contains expected elements, error' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(%w[error])
    end
  end

  describe 'PUT /teachers/:id/update_profil' do
    before do
      teacher.save
      post '/api/v1/login', params:
        {
          :login => {
            account_type: 'Teacher',
            email: 'user_teacher@example.com',
            password: 'password'
          }
        }
      json_response = JSON.parse(response.body)
      put "/api/v1/teachers/#{teacher.id}/update_profil", params:
      {
        :teacher => {
          fullname: 'new name',
          phone: 'new phone',
          bio: 'new bio',
          what_I_can_do: 'new what I can do',
          photo: 'new photo'
        },
        :categories => [],
      }, headers:
      {
        Authorization:  "Bearer #{json_response["access"]}"
      }
    end
    it 'returns http ok' do
      expect(response).to have_http_status(:ok)
    end
    it 'JSON body response contains expected elements, current_user, categories' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(%w[current_user categories])
    end
    it 'the student has the new name' do
      json_response = JSON.parse(response.body)
      expect(json_response["current_user"]["fullname"]).to eq('new name')
    end
    it 'the student has the new phone' do
      json_response = JSON.parse(response.body)
      expect(json_response["current_user"]["phone"]).to eq('new phone')
    end
    it 'the student has the new bio' do
      json_response = JSON.parse(response.body)
      expect(json_response["current_user"]["bio"]).to eq('new bio')
    end
    it 'the student has the new what_I_can_do' do
      json_response = JSON.parse(response.body)
      expect(json_response["current_user"]["what_I_can_do"]).to eq('new what I can do')
    end
    it 'the student has the new photo' do
      json_response = JSON.parse(response.body)
      expect(json_response["current_user"]["photo"]).to eq('new photo')
    end
  end

  describe 'PUT /teachers/:id/update_profil without a token' do
    before do
      teacher.save
      put "/api/v1/teachers/#{teacher.id}/update_profil", params:
      {
        :teacher => {
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

  describe 'PUT /teachers/:id/update_profil with wrong id' do
    before do
      teacher.save
      post '/api/v1/login', params:
        {
          :login => {
            account_type: 'Teacher',
            email: 'user_teacher@example.com',
            password: 'password'
          }
        }
      json_response = JSON.parse(response.body)
      put "/api/v1/teachers/#{teacher.id + 100}/update_profil", params:
      {
        :teacher => {
          fullname: 'new name',
          phone: 'new phone',
          bio: 'new bio',
          what_I_can_do: 'new what I can do',
          photo: 'new photo'
        },
        :categories => [],
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

  describe 'PUT /teachers/:id/update_profil with wrong params' do
    before do
      teacher.save
      post '/api/v1/login', params:
        {
          :login => {
            account_type: 'Teacher',
            email: 'user_teacher@example.com',
            password: 'password'
          }
        }
      json_response = JSON.parse(response.body)
      put "/api/v1/teachers/#{teacher.id}/update_profil", params:
      {
        :teacher => {
          fullname: '',
          phone: 'new phone',
          bio: 'new bio',
          what_I_can_do: 'new what I can do',
          photo: 'new photo'
        },
        :categories => [],
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

  describe 'PUT /teachers/:id/update_schedule' do
    before do
      teacher.save
      post '/api/v1/login', params:
        {
          :login => {
            account_type: 'Teacher',
            email: 'user_teacher@example.com',
            password: 'password'
          }
        }
      json_response = JSON.parse(response.body)
      put "/api/v1/teachers/#{teacher.id}/update_schedule", params:
      {
        :schedule => {
          monday: 'monady',
          friday: 'friday'
        },
      }, headers:
      {
        Authorization:  "Bearer #{json_response["access"]}"
      }
    end
    it 'returns http ok' do
      expect(response).to have_http_status(:ok)
    end
    it 'JSON body response contains expected elements, schedule' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to include('schedule')
    end
    it 'the student has the new schedule' do
      json_response = JSON.parse(response.body)
      expect(json_response["schedule"]).to eq({
        "monday" => 'monady',
        "friday" => 'friday'
      })
    end
  end

  describe 'PUT /teachers/:id/update_schedule without a token' do
    before do
      teacher.save
      put "/api/v1/teachers/#{teacher.id}/update_schedule", params:
      {
        :schedule => {
          monday: 'monady',
          friday: 'friday'
        },
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

  describe 'PUT /teachers/:id/update_schedule with wrong id' do
    before do
      teacher.save
      post '/api/v1/login', params:
        {
          :login => {
            account_type: 'Teacher',
            email: 'user_teacher@example.com',
            password: 'password'
          }
        }
      json_response = JSON.parse(response.body)
      put "/api/v1/teachers/#{teacher.id + 100}/update_schedule", params:
      {
        :schedule => {
          monday: 'monady',
          friday: 'friday'
        },
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

  describe 'PUT /teachers/:id/update_session_type' do
    before do
      teacher.save
      post '/api/v1/login', params:
        {
          :login => {
            account_type: 'Teacher',
            email: 'user_teacher@example.com',
            password: 'password'
          }
        }
      json_response = JSON.parse(response.body)
      put "/api/v1/teachers/#{teacher.id}/update_session_type", params:
      {
        :session_type => "online, shop"
      }, headers:
      {
        Authorization:  "Bearer #{json_response["access"]}"
      }
    end
    it 'returns http ok' do
      expect(response).to have_http_status(:ok)
    end
    it 'JSON body response contains expected elements, session_type' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to include('session_type')
    end
    it 'the student has the new session_type' do
      json_response = JSON.parse(response.body)
      expect(json_response["session_type"]).to eq("online, shop")
    end
  end

  describe 'PUT /teachers/:id/update_session_type without a token' do
    before do
      teacher.save
      put "/api/v1/teachers/#{teacher.id}/update_session_type", params:
      {
        :session_type => "online, shop"
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

  describe 'PUT /teachers/:id/update_session_type with wrong id' do
    before do
      teacher.save
      post '/api/v1/login', params:
        {
          :login => {
            account_type: 'Teacher',
            email: 'user_teacher@example.com',
            password: 'password'
          }
        }
      json_response = JSON.parse(response.body)
      put "/api/v1/teachers/#{teacher.id + 100}/update_session_type", params:
      {
        :session_type => "online, shop"
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
