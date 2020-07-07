require 'rails_helper'
RSpec.describe Api::V1::TeachersController do
  describe 'POST /api/v1/teachers/:id' do
    let(:teacher) { build(:teacher) }
    before do
      teacher.save
      get "/api/v1/teachers/#{teacher.id}"
    end
    it 'returns http created' do
      expect(response).to have_http_status(:ok)
    end
    it 'JSON body response contains expected elements' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(%w[teacher categories])
    end
  end
end
