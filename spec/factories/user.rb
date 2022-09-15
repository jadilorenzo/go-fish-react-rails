FactoryBot.define do
  factory :user do
    name { "Braden" }
    email { "bradenwrich@gmail.com" }
    password { "password" }
    password_confirmation { "password" }

    trait :player1 do
      name { 'Caleb' }
      email { 'caleb@example.com' }
    end
  end
end
