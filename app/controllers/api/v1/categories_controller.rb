module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: [:get_teachers_by_categories]

      def get_teachers_by_categories
        render json: { teachers: @category.teachers }, status: :ok
      end

      private
      def set_category
        @category = Category.find_by(name: params[:name])
      end
    end
  end
end