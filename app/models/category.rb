class Category < ApplicationRecord
  has_many :join_category_teachers
  has_many :teachers, through: :join_category_teachers
end
