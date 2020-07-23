module Api
  module V1
    class StudentsController < ApplicationController
      before_action :authorize_access_request!, only: [:update_profile]
      before_action :set_student

      def update_profile
        if @student.update(student_params)
          render json: { current_user: @student }, status: :ok
        else
          render json: { error: @student.errors }, status: 400
        end
      end

      private

      def student_params
        params.require(:student).permit(:fullname, :phone)
      end

      def set_student
        @student = Student.find_by(id: params[:id])
        render json: { error: 'Record not found' }, status: 400 if @student.nil?
      end
    end
  end
end
