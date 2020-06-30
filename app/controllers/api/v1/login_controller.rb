module Api
  module V1
    class LoginController < ApplicationController
      before_action :authorize_refresh_request!, only: [:destroy]
      before_action :authorize_refresh_by_access_request!, only: [:refresh]

      def create
        account_type = params[:account_type]
        if account_type == 'student'
        elsif account_type == 'teacher'
          @user = Teacher.find_by(email: params[:email])
        end

        if @user.authenticate(params[:password])
          payload = { user_id: @user.id }
          session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
          tokens = session.login
          response.set_cookie(JWTSessions.access_cookie, value: tokens[:access], httponly: true, secure: Rails.env.production? )

          render json: { csrf: tokens[:csrf] }, status: :created
        else
          render json: "Invalid user", status: :unauthorized
        end
      end
    
      def refresh
        session = JWTSessions::Session.new(payload: claimless_payload, refresh_by_access_allowed: true)
        tokens = session.refresh_by_access_allowed do
          raise JWTSessions::Errors::Unauthorized, "Somethings not right here!"
        end

        response.set_cookie(JWTSessions.access_cookie, value: tokens[:access], httponly: true, secure: Rails.env.production? )
        render json: { csrf: tokens[:csrf], access: tokens[:access] }
      end

      def destroy
      end
    end
    
  end
end