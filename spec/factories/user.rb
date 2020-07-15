FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password { 'supersekrit' }
    password_confirmation { 'supersekrit' }
  end
end
