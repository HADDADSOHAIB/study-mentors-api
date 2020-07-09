module Api
  module V1
    class TeachersController < ApplicationController
      before_action :authorize_access_request!, except: [:teacher]
      before_action :set_teacher, only: %i[update_profile update_schedule update_session_type teacher]

      def teacher
        render json: { teacher: @teacher, categories: @teacher.categories || [] }, status: :ok
      end

      def update_profile
        categories_map = {
          maths: 1,
          physics: 2,
          arts: 3,
          english: 4
        }
        JoinCategoryTeacher.where(teacher_id: @teacher.id).to_a.each(&:destroy)
        params[:categories].each do |k, v|
          @teacher.categories << Category.find(categories_map[k.to_sym]) if v
        end

        if @teacher.update(teacher_params)
          render json: { current_user: @teacher, categories: @teacher.categories || [] }, status: :ok
        else
          render json: { error: @teacher.errors }, status: 400
        end
      end

      def update_schedule
        if @teacher.update(schedule: params[:schedule])
          render json: @teacher, status: :ok
        else
          render json: { error: @teacher.errors }, status: 400
        end
      end

      def update_session_type
        if @teacher.update(session_type: params[:session_type])
          render json: @teacher, status: :ok
        else
          render json: { error: @teacher.errors }, status: 400
        end
      end

      private

      def set_teacher
        @teacher = Teacher.find_by(id: params[:id])
        render json: { error: 'Record not found' }, status: 400 if @teacher.nil?
      end

      def teacher_params
        params.require(:teacher).permit(:fullname, :phone, :bio, :what_I_can_do, :photo)
      end
    end
  end
end
