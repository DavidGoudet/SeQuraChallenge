# spec/factories/merchants_factory.rb

FactoryBot.define do
    factory :merchant do
      reference { Faker::Alphanumeric.alphanumeric(number: 10) } # Generate a unique reference
      email { Faker::Internet.email }
      sequence(:internal_id) { |n| n }
      live_on { Faker::Date.between(from: 1.year.ago, to: Time.now.utc) }
      disbursement_frequency { ['daily', 'weekly'].sample }
      minimum_monthly_fee { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
      # Add other attributes as needed
    end
  end