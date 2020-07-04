module Api
  module V1
    class StudentsController < ApplicationController
      before_action :authorize_refresh_request!, only: [:update_profile]
      before_action :set_student

      def update_profile
        if @student.update(student_params)
          render json: { current_user: @student }, status: :ok
        else
          render json: @student.errors, status: :unprocessable_entity
        end
      end

      private
      def student_params
        params.require(:student).permit(:fullname, :phone)
      end

      def set_student
        @student = Student.find(params[:id])
        if @student.nil?
          render json: { message: 'Record not found' }, status: 400
        end
      end
    end
  end
end