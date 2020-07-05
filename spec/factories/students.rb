FactoryBot.define do
  factory :student do
    sequence :id
    fullname { 'UserTest' }
    email { "usertest#{id}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
