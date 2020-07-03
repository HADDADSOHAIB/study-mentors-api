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

      def my_bookings
        if params[:account_type] == "Student"
          @user = Student.find(params[:id])
        else
          @user = Teacher.find(params[:id])
        end
        bookings = []
        @user.bookings.to_a.each do |booking|
          bookings << {
            id: booking.id,
            teacher: booking.teacher,
            student: booking.student,
            category: booking.category,
            date: booking.date,
            from: booking.from,
            to: booking.to,
            session_type: booking.session_type
          }
        end

        render json: { bookings: bookings }, status: :ok
      end
    end
  end
end