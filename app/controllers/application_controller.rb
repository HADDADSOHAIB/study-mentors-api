class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  private

  def current_user
    if payload["account_type"] == "Teacher"
      @current_user ||= Teacher.find(payload["user_id"])
    else
      @current_user ||= Student.find(payload["user_id"])
    end
  end
  
  def not_authorized
    render json: { error: "Not authorized" }, status: :unauthorized
  end
end
