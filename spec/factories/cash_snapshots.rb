
FactoryBot.define do
  factory :cash_snapshot do
    association :user
    total_balance      { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    available_cash     { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    total_investments  { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    profit_loss        { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    currency           { "EUR" }
  end
end
