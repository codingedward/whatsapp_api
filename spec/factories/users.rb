FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number_with_country_code }
    status { Faker::Lorem.sentence }
  end
end
