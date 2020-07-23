class JoinCategoryTeacher < ApplicationRecord
  belongs_to :teacher
  belongs_to :category
end
