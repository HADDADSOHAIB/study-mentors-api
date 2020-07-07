FactoryBot.define do
  factory :teacher, class: 'Teacher' do
    sequence :id
    fullname { 'UserTest' }
    email { 'user_teacher@example.com' }
    password { 'password' }
  end
end
