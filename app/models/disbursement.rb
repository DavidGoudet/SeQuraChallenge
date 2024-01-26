class Disbursement < ApplicationRecord
  belongs_to :merchant

  def self.calculate_for_merchant(merchant)
    # Determine the current UTC time
    current_time_utc = Time.now.utc

    # Determine the current UTC day of the week (0 = Sunday, 1 = Monday, etc.)
    current_day_of_week = current_time_utc.wday

    # Check if the merchant has a weekly disbursement frequency and a live_on date
    if merchant.disbursement_frequency == 'weekly' && merchant.live_on.present?
      # Calculate the day of the week (0-6) corresponding to the merchant's live_on date
      live_on_day_of_week = merchant.live_on.wday

      # Check if today is the same day of the week as the merchant's live_on date
      if current_day_of_week == live_on_day_of_week
        # This merchant is eligible for a weekly disbursement today
        eligible_orders = merchant.orders.where("created_at >= ? AND created_at <= ?", 1.week.ago, current_time_utc)
      else
        # This merchant is not eligible for a disbursement today
        eligible_orders = []
      end
    else
      # This merchant has a daily disbursement frequency
      eligible_orders = merchant.orders.where("created_at >= ? AND created_at <= ?", 1.day.ago, current_time_utc)
    end

    # Calculate the total amount of eligible orders
    total_amount = eligible_orders.sum(&:amount)

    # Calculate the total fee for eligible orders (assuming calculate_fee is a method in your Order model)
    total_fee = eligible_orders.sum(&:calculate_fee)

    # Calculate the net amount (total amount minus total fee)
    net_amount = total_amount - total_fee
    

    # Create a disbursement record for the merchant
    unless eligible_orders.empty?
      create(merchant: merchant, amount: net_amount, fee: total_fee, disbursement_date: current_time_utc)
    end

    # Return the created disbursement record if needed
    # return disbursement_record
  end
end

