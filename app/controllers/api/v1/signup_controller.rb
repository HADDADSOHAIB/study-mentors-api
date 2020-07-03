module Api
  module V1
    class SignupController < ApplicationController
      def create
        account_type = params[:account_type]
        if account_type == 'Student'
          @user = Student.new(user_params)
        elsif account_type == 'Teacher'
          @user = Teacher.new(user_params)
        end
    
        if @user.save
          payload = { user_id: @user.id }
          session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true )
          tokens = session.login
          response.set_cookie(JWTSessions.access_cookie, value: tokens[:access], httponly: true, secure: Rails.env.production? )

          render json: { csrf: tokens[:csrf], access: tokens[:access], curent_user: @user, categories: [] }, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def check_uniqueness
        email = Teacher.find_by(email: params[:email]) || Student.find_by(email: params[:email])
        render json: { email: !!!email }
      end

      def user_params
        params.require(:user).permit(:fullname, :email, :password)
      end
    end
  end
end