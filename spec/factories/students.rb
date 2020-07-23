FactoryBot.define do
  factory :student, class: 'Student' do
    sequence :id
    fullname { 'UserTest' }
    email { 'user_student@example.com' }
    password { 'password' }
  end
end
