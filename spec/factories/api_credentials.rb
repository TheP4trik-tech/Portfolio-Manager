FactoryBot.define do
  factory :api_credential do
    association :user
    api_key  { Faker::Alphanumeric.alphanumeric(number: 32) }
    api_id   { Faker::Alphanumeric.alphanumeric(number: 16) }
    provider { "trading212" }

    trait :etoro do
      provider { "etoro" }
    end

    trait :invalid do
      api_key { "invalid_key" }
      api_id  { "invalid_id" }
    end
  end
end
