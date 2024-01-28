class Disbursement < ApplicationRecord
  belongs_to :merchant

  def self.calculate_for_merchant(merchant, time = Time.now.utc)
    MinimumExtraFee.calculate_minimum_reached(merchant, time)
    eligible_orders = self.get_orders(merchant, time)

    total_amount = eligible_orders.sum(&:amount)
    total_fee = eligible_orders.sum(&:calculate_fee)
    net_amount = total_amount - total_fee

    unless eligible_orders.empty?
      create(merchant: merchant, amount: net_amount, fee: total_fee, disbursement_date: time)
    end
  end

  private

  def self.get_orders(merchant, current_time_utc)
    current_day_of_week = current_time_utc.wday
    if merchant.disbursement_frequency == 'weekly' && merchant.live_on.present?
      live_on_day_of_week = merchant.live_on.wday
      if current_day_of_week == live_on_day_of_week
        start_time = (current_time_utc - 8.days).beginning_of_day + 8.hours
        end_time = current_time_utc.beginning_of_day + 8.hours
        merchant.orders.where("created_at >= ? AND created_at <= ?", start_time, end_time)
      else
        []
      end
    else
      start_time = (current_time_utc - 1.day).beginning_of_day + 8.hours
      end_time = current_time_utc.beginning_of_day + 8.hours
      merchant.orders.where("created_at >= ? AND created_at <= ?", start_time, end_time)
    end
  end
end



