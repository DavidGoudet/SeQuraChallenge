# spec/factories/orders_factory.rb

FactoryBot.define do
    factory :order do
      amount { Faker::Commerce.price(range: 10..1000, as_string: true) }
      merchant_id { association(:merchant) }
      sequence(:internal_id) { |n| n }
      created_at { Faker::Time.between(from: 1.year.ago, to: Time.zone.now) }
      # Add other attributes as needed
    end
  end
  