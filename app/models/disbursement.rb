class Disbursement < ApplicationRecord
  belongs_to :merchant

  def self.calculate_for_merchant(merchant)
    MinimumExtraFee.calculate_minimum_reached(merchant)
    eligible_orders = self.get_orders(merchant)

    total_amount = eligible_orders.sum(&:amount)
    total_fee = eligible_orders.sum(&:calculate_fee)
    net_amount = total_amount - total_fee

    unless eligible_orders.empty?
      create(merchant: merchant, amount: net_amount, fee: total_fee, disbursement_date: Time.now.utc)
    end
  end

  private

  def self.get_orders(merchant)
    current_time_utc = Time.now.utc
    current_day_of_week = current_time_utc.wday
    if merchant.disbursement_frequency == 'weekly' && merchant.live_on.present?
      live_on_day_of_week = merchant.live_on.wday
      if current_day_of_week == live_on_day_of_week
        merchant.orders.where("created_at >= ? AND created_at <= ?", 1.week.ago, current_time_utc)
      else
        []
      end
    else
      merchant.orders.where("created_at >= ? AND created_at <= ?", 1.day.ago, current_time_utc)
    end
  end
end



