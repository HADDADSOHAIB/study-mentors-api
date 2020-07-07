module Api
  module V1
    class BookingsController < ApplicationController
      before_action :authorize_access_request!

      def create
        teacher = Teacher.find(create_params[:teacher_id])
        student = Student.find(create_params[:student_id])
        category = Category.find(create_params[:category_id])

        @booking = Booking.new(
          teacher: teacher,
          student: student,
          category: category,
          session_type: create_params[:type],
          date: create_params[:from],
          from: create_params[:from],
          to: create_params[:to]
        )

        if @booking.save
          render json: { booking: @booking }, status: :created
        else
          render json: @booking.errors, status: :unprocessable_entity
        end
      end

      def my_bookings
        @user = if my_bookings_params[:account_type] == 'Student'
                  Student.find(my_bookings_params[:id])
                else
                  Teacher.find(my_bookings_params[:id])
                end
        render json: @user.bookings.to_json(include: [:student, :teacher, :category]), status: :ok
      end

      private

      def my_bookings_params
        params.require(:booking).permit(:id, :account_type)
      end

      def create_params
        params.require(:booking).permit(:teacher_id, :student_id, :category_id, :type, :from, :to)
      end
    end
  end
end
