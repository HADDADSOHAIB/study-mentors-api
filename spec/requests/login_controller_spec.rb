require 'rails_helper'
RSpec.describe Api::V1::LoginController do
  describe "POST /api/v1/login" do
    let(:student) { build(:student) }
    before do
      student.save
      post '/api/v1/login', params: { account_type: 'Student', email: 'user_student@example.com', password: 'password'}
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "JSON body response contains expected elements" do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(["csrf", "access", "current_user", "categories"])
    end
  end

  describe "POST /api/v1/login with invalid password" do
    let(:student) { build(:student) }
    before do
      student.save
      post '/api/v1/login', params: { account_type: 'Student', email: 'user_student@example.com', password: 'passwordd'}
    end
    it "returns http success" do
      expect(response).to have_http_status(:unauthorized)
    end
    it "JSON body response contains expected elements" do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(["message"])
    end
  end
end
