module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: [:teachers_by_categories]

      def teachers_by_categories
        render json: { teachers: @category.teachers }, status: :ok
      end

      private

      def set_category
        @category = Category.find_by(name: category_params[:name])
      end

      def category_params
        params.permit(:name)
      end
    end
  end
end
