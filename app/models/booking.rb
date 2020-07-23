class Booking < ApplicationRecord
  belongs_to :teacher
  belongs_to :student
  belongs_to :category
end
