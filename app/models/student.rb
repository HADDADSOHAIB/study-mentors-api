class Student < ApplicationRecord
  has_secure_password
  validates :email, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'The email is not valid' } 
  validates :fullname, :email, presence: true

  has_many :bookings
end
