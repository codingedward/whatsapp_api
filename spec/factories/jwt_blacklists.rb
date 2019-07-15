FactoryBot.define do
  factory :jwt_blacklist do
    token { Faker::Lorem.word }
  end
end
