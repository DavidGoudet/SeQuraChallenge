FactoryBot.define do
  factory :minimum_extra_fee do
    fee_amount { "9.99" }
    merchant { nil }
    disbursement { nil }
  end
end
