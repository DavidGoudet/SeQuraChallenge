# spec/models/disbursement_spec.rb

require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  describe '.calculate_for_merchant' do
    let(:merchant) { create(:merchant) }
    let!(:eligible_order1) { create(:order, merchant: merchant, amount: 100.0) }
    let!(:eligible_order2) { create(:order, merchant: merchant, amount: 200.0) }
    let!(:eligible_order3) { create(:order, merchant: merchant, amount: 200.0) }
    let!(:ineligible_order) { create(:order, merchant: merchant, amount: 50.0) }

    it 'calculates the disbursement for a merchant with daily frequency' do
      merchant.update(disbursement_frequency: 'daily')
      order = merchant.orders.first
      order.update(created_at: Time.now.utc, amount: 350)

      expect do
        Disbursement.calculate_for_merchant(merchant)
      end.to change(Disbursement, :count).by(1)

      disbursement = Disbursement.last
      expect(disbursement.amount).to eq(347.02)
      expect(disbursement.fee).to eq(2.98) # Adjust based on your fee calculation logic
    end

    it 'calculates the disbursement for a merchant with weekly frequency on the right day' do
      merchant.update(disbursement_frequency: 'weekly', live_on: Time.now.utc)
      order = merchant.orders.first
      order.update(created_at: Time.now.utc-2.day, amount: 52)

      # Calculate the day of the week corresponding to today (0 = Sunday, 1 = Monday, etc.)
      today_day_of_week = Time.now.utc.wday

      # Set the live_on_day_of_week to the same as today
      merchant.live_on = Time.now.utc

      expect do
        Disbursement.calculate_for_merchant(merchant)
      end.to change(Disbursement, :count).by(1)

      disbursement = Disbursement.last
      expect(disbursement.amount).to eq(51.51)
      expect(disbursement.fee).to eq(0.49) # Adjust based on your fee calculation logic
    end

    it 'does not calculate the disbursement for a merchant with weekly frequency on the wrong day' do
      merchant.update(disbursement_frequency: 'weekly', live_on: Time.now.utc)

      # Calculate the day of the week corresponding to today (0 = Sunday, 1 = Monday, etc.)
      today_day_of_week = Time.now.utc.wday

      # Set the live_on_day_of_week to a different day than today
      merchant.live_on = Time.now.utc + 1

      expect do
        Disbursement.calculate_for_merchant(merchant)
      end.not_to change(Disbursement, :count)
    end

    it 'calculates the disbursement correctly for several pricing levels' do
      merchant.update(disbursement_frequency: 'daily')
      order1 = merchant.orders.first
      order2 = merchant.orders.second
      order3 = merchant.orders.third
      order1.update(created_at: Time.now.utc, amount: 13.4) # Fee: 0.13
      order2.update(created_at: Time.now.utc, amount: 50) # Fee: 0.48
      order3.update(created_at: Time.now.utc, amount: 350) # Fee: 2.98

      expect do
        Disbursement.calculate_for_merchant(merchant)
      end.to change(Disbursement, :count).by(1)

      disbursement = Disbursement.last
      expect(disbursement.amount).to eq(409.81)
      expect(disbursement.fee).to eq(3.59)
    end
  end
end
