# lib/tasks/year_calculator.rake

namespace :year_calculator do
    desc "Calculate various metrics for a given year"

    task :run_year_disbursements, [:year] => :environment do |_, args|
        year = args[:year].to_i
        start_date = Date.new(year, 1, 1)
        end_date = Date.new(year, 12, 31)
        current_date = start_date
        while current_date <= end_date
            current_time = Time.utc(year, current_date.month, current_date.day, 7, 0, 0)
            for merchant in Merchant.all
                Disbursement.calculate_for_merchant(merchant, current_time)
            end
            current_date += 1.day
        end
    end
  
    task :calculate, [:year] => :environment do |_, args|
      year = args[:year].to_i

      disbursements_count = Disbursement.where("strftime('%Y', disbursement_date) = ?", year.to_s).count
      total_disbursed_amount = Disbursement.where("strftime('%Y', disbursement_date) = ?", year.to_s).sum(:amount)
      total_order_fees = Disbursement.where("strftime('%Y', disbursement_date) = ?", year.to_s).sum(:fee)
      total_monthly_fees = MinimumExtraFee.where("strftime('%Y', created_at) = ?", year.to_s).count
      total_monthly_fees_amount = MinimumExtraFee.where("strftime('%Y', created_at) = ?", year.to_s).sum(:fee_amount)

      puts "Year: #{year}"
      puts "Number of Disbursements: #{disbursements_count}"
      puts "Total Disbursed Amount: #{total_disbursed_amount}"
      puts "Total Order Fees: #{total_order_fees}"
      puts "Number of monthly fees charged: #{total_monthly_fees}"
      puts "Amount of monthly fee charged: #{total_monthly_fees_amount}"
    end
  end
  