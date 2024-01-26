namespace :disbursements do
  desc "TODO"
  task daily_disbursements: :environment do
    # Determine the current UTC time
    current_time_utc = Time.now.utc

    # Check if it's 8:00 UTC (adjust the time as needed)
    if current_time_utc.hour == 8 && current_time_utc.min == 0
      # Iterate through all merchants
      Merchant.find_each do |merchant|
        # Calculate daily disbursements for each merchant
        Disbursement.calculate_for_merchant(merchant)
      end
    else
      # It's not 8:00 UTC; do nothing
      puts 'Not yet time for daily disbursements.'
    end
  end

end
