module Api
  module V1
    class LoginController < ApplicationController
      before_action :authorize_refresh_request!, only: [:destroy]
      before_action :authorize_refresh_by_access_request!, only: [:refresh]
      before_action :authorize_access_request!, only: [:user_by_token]

      def create
        account_type = params[:account_type]
        if account_type == 'Student'
          @user = Student.find_by(email: params[:email])
          @categories = []
        elsif account_type == 'Teacher'
          @user = Teacher.find_by(email: params[:email])
          @categories = @user.categories
        end

        if @user.authenticate(params[:password])
          payload = { user_id: @user.id, account_type: account_type }
          session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
          tokens = session.login
          response.set_cookie(
            JWTSessions.access_cookie,
            value: tokens[:access],
            httponly: true,
            secure: Rails.env.production?
          )

          render json: {
            csrf: tokens[:csrf],
            access: tokens[:access],
            current_user: @user,
            categories: @categories
          }, status: :created
        else
          render json: { message: 'Invalid Credentials' }, status: :unauthorized
        end
      end

      def user_by_token
        if current_user
          categories = payload['account_type'] == 'Teacher' ? current_user.categories : []
          render json: {
            current_user: current_user,
            account_type: payload['account_type'],
            categories: categories
          }, status: :ok
        else
          render json: { message: 'There is an error' }, status: :unprocessable_entity
        end
      end
    end
  end
end
