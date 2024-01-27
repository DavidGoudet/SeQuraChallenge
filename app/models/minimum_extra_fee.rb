class MinimumExtraFee < ApplicationRecord
  belongs_to :merchant

  def self.calculate_minimum_reached(merchant)
    if self.is_first_day(merchant)
      current_time_utc = Time.now.utc
      first_day_of_previous_month = current_time_utc.prev_month.beginning_of_month
      previous_month_range = first_day_of_previous_month..first_day_of_previous_month.end_of_month
      eligible_orders = merchant.orders.where(created_at: previous_month_range)
      total_amount = eligible_orders.sum(&:amount)
      total_fee = eligible_orders.sum(&:calculate_fee)
      net_amount = total_amount - total_fee
      amount_to_reach_minimum_fee = [0, merchant.minimum_monthly_fee - total_fee].max
      if total_fee < amount_to_reach_minimum_fee
        create(fee_amount: amount_to_reach_minimum_fee, merchant: merchant)
      end
    end
  end

  private

  def self.is_first_day(merchant)
    current_time_utc = Time.now.utc
    current_day_of_month = current_time_utc.day
    current_day_of_week = current_time_utc.wday
    if merchant.disbursement_frequency == 'weekly' && merchant.live_on.present?
      current_day_of_week == merchant.live_on.wday && current_day_of_month <= 7
    else
      current_day_of_month == 1
    end
  end
end
