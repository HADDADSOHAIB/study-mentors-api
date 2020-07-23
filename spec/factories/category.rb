FactoryBot.define do
  factory :category, class: 'Category' do
    sequence :id
    name { 'category' }
  end
end
