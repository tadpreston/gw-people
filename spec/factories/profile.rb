FactoryBot.define do
  factory :profile do
    first_name { "Hamilton" }
    last_name { "Porter" }
    about { "The great bambino" }

    user
  end
end
