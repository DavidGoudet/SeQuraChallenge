# spec/models/minimum_extra_fee_spec.rb

require 'rails_helper'
require 'timecop'

RSpec.describe MinimumExtraFee, type: :model do
  describe '.calculate_minimum_reached' do
    let(:merchant) { create(:merchant) }
    let!(:eligible_order1) { create(:order, merchant: merchant, amount: 100.0) }
    let!(:eligible_order2) { create(:order, merchant: merchant, amount: 200.0) }
    let!(:eligible_order3) { create(:order, merchant: merchant, amount: 200.0) }
    let!(:ineligible_order) { create(:order, merchant: merchant, amount: 50.0) }

    it 'calculates the minimum extra fee for a daily merchant' do
      target_time = Time.utc(2022, 3, 1, 15, 30, 0)
      Timecop.travel(target_time)
      merchant.update(disbursement_frequency: 'daily')
      merchant.update(minimum_monthly_fee: 30)
      order = merchant.orders.first
      order.update(created_at: Time.utc(2022, 2, 20, 15, 30, 0), amount: 350)

      expect do
        Disbursement.calculate_for_merchant(merchant)
      end.to change(MinimumExtraFee, :count).by(1)
      extra_fee = MinimumExtraFee.last
      expect(extra_fee.fee_amount).to eq(27.02)
      Timecop.return
    end
    it 'calculates the minimum extra fee for a weekly merchant' do
        target_time = Time.utc(2022, 3, 1, 15, 30, 0)
        Timecop.travel(target_time)
        merchant.update(disbursement_frequency: 'weekly', live_on: Time.utc(2022, 2, 1, 15, 30, 0))
        merchant.update(minimum_monthly_fee: 30)
        order = merchant.orders.first
        order.update(created_at: Time.utc(2022, 2, 20, 15, 30, 0), amount: 20)

        expect do
        Disbursement.calculate_for_merchant(merchant)
        end.to change(MinimumExtraFee, :count).by(1)
        extra_fee = MinimumExtraFee.last
        expect(extra_fee.fee_amount).to eq(29.8)
        Timecop.return
    end
    it 'doesnt create an extra fee when its not needed' do
        target_time = Time.utc(2022, 3, 1, 15, 30, 0)
      Timecop.travel(target_time)
      merchant.update(disbursement_frequency: 'daily')
      merchant.update(minimum_monthly_fee: 2)
      order = merchant.orders.first
      order.update(created_at: Time.utc(2022, 2, 20, 15, 30, 0), amount: 350)

      expect do
        Disbursement.calculate_for_merchant(merchant)
      end.not_to change(MinimumExtraFee, :count)
      Timecop.return
    end
  end
end