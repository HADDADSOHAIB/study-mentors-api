module Api
  module V1
    class BookingsController < ApplicationController
      def create
        teacher = Teacher.find(params[:teacher_id])
        student = Student.find(params[:student_id])
        category = Category.find(params[:category_id])

        @booking = Booking.new(
          teacher: teacher,
          student: student,
          category: category,
          session_type: params[:type],
          date: params[:from],
          from: params[:from],
          to: params[:to]
        )

        if @booking.save
          render json: { booking: @booking  }, status: :created
        else
          render json: @booking.errors, status: :unprocessable_entity
        end
      end
    end
  end
end