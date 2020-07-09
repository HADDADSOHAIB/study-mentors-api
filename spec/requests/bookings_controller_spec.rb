require 'rails_helper'

RSpec.describe Api::V1::BookingsController do
  let(:maths) { build(:category, name: 'maths') }
  let(:teacher) { build(:teacher) }
  let(:student) { build(:student) }

  describe 'POST bookings' do
    before do
      maths.save
      teacher.save
      student.save
      post '/api/v1/login', params:
        {
          login: { account_type: 'Student', email: 'user_student@example.com', password: 'password' }
        }
      json_response = JSON.parse(response.body)
      post '/api/v1/bookings', params:
      {
        booking: { teacher_id: teacher.id, student_id: student.id, category_id: maths.id,
                   type: 'online', from: Date.new, to: Date.new }
      }, headers:
      {
        Authorization: "Bearer #{json_response['access']}"
      }
    end
    it 'returns http created' do
      expect(response).to have_http_status(:created)
    end
    it 'JSON body response contains expected elements, booking' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(%w[booking])
    end
  end

  describe 'POST bookings without token' do
    before do
      maths.save
      teacher.save
      student.save
      post '/api/v1/bookings', params:
      { booking: { teacher_id: teacher.id, student_id: student.id, category_id: maths.id,
                   type: 'online', from: Date.new, to: Date.new } }
    end
    it 'returns http unthorized' do
      expect(response).to have_http_status(:unauthorized)
    end
    it 'JSON body response contains expected elements, error' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(%w[error])
    end
  end

  describe 'POST bookings/my_bookings' do
    before do
      maths.save
      teacher.save
      student.save
      post '/api/v1/login', params:
        { login: { account_type: 'Student', email: 'user_student@example.com',
                   password: 'password' } }
      json_response = JSON.parse(response.body)
      token = json_response['access']
      post '/api/v1/bookings', params:
      { booking: { teacher_id: teacher.id, student_id: student.id, category_id: maths.id,
                   type: 'online', from: Date.new, to: Date.new } },
                               headers: { Authorization: "Bearer #{token}" }
      post '/api/v1/bookings/my_bookings', params:
      {
        booking: {
          id: teacher.id,
          account_type: 'Teacher'
        }
      }, headers:
      {
        Authorization: "Bearer #{token}"
      }
    end
    it 'returns http ok' do
      expect(response).to have_http_status(:ok)
    end
    it 'my bookings include my id as teacher' do
      json_response = JSON.parse(response.body)
      expect(json_response[0]['teacher']['id']).to eq(teacher.id)
    end
    it 'my bookings include my id as student' do
      json_response = JSON.parse(response.body)
      expect(json_response[0]['student']['id']).to eq(student.id)
    end
    it 'my bookings include the category' do
      json_response = JSON.parse(response.body)
      expect(json_response[0]['category']['id']).to eq(maths.id)
    end
  end

  describe 'POST bookings/my_bookings without token' do
    before do
      maths.save
      teacher.save
      student.save
      post '/api/v1/login', params:
        { login: { account_type: 'Student', email: 'user_student@example.com',
                   password: 'password' } }
      json_response = JSON.parse(response.body)
      token = json_response['access']
      post '/api/v1/bookings', params:
      { booking: { teacher_id: teacher.id, student_id: student.id, category_id: maths.id,
                   type: 'online', from: Date.new, to: Date.new } },
                               headers: { Authorization: "Bearer #{token}" }
      post '/api/v1/bookings/my_bookings', params:
      { booking: { id: teacher.id, account_type: 'Teacher' } }
    end
    it 'returns http unthorized' do
      expect(response).to have_http_status(:unauthorized)
    end
    it 'JSON body response contains expected elements, error' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(%w[error])
    end
  end
end
