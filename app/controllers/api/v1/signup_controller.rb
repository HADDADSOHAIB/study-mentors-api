module Api
  module V1
    class SignupController < ApplicationController
      def create
        account_type = params[:account_type]
        if account_type == 'student'
        elsif account_type == 'teacher'
          @user = User.new(teacher_params)
        end
    
        if @user.save
          payload = { user_id: @user.id }
          session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true )
          tokens = session.login
          response.set_cookie(JWTSessions.access_cookie, value: tokens[:access], httponly: true, secure: Rails.env.production? )

          render json: { csrf: tokens[:csrf], access: tokens[:access] }, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def teacher_params
        params.require(:user).permit(:fullname, :email, :phone, :bio, :what_I_can_do, :sechdule, :session_type)
      end
    end
  end
end