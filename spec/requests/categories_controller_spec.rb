require 'rails_helper'

RSpec.describe Api::V1::CategoriesController do
  let(:maths) { build(:category, name: 'maths') }
  let(:teacher) { build(:teacher) }
  describe 'GET categories/:name/teachers' do
    before do
      maths.save
      teacher.save

      post '/api/v1/login', params:
        {
          login: {
            account_type: 'Teacher',
            email: 'user_teacher@example.com',
            password: 'password'
          }
        }
      json_response = JSON.parse(response.body)
      put "/api/v1/teachers/#{teacher.id}/update_profil", params:
      {
        teacher: {
          fullname: 'new name'
        },
        categories: %w[maths physics]
      }, headers:
      {
        Authorization: "Bearer #{json_response['access']}"
      }
      get '/api/v1/categories/maths/teachers'
    end
    it 'returns http ok' do
      expect(response).to have_http_status(:ok)
    end
    it 'JSON body response contains expected elements, teachers' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(%w[teachers])
    end
  end
end
