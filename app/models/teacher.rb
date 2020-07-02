class Teacher < ApplicationRecord
  attr_accessor :category_list

  has_secure_password
  validates :email, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'The email is not valid' } 
  validates :fullname, :email, presence: true

  has_many :join_category_teachers
  has_many :categories, through: :join_category_teachers
end
