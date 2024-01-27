# lib/tasks/year_calculator.rake

namespace :year_calculator do
    desc "Calculate various metrics for a given year"
  
    task :calculate, [:year] => :environment do |_, args|
      year = args[:year].to_i
  
      # Perform calculations here based on the provided year
      disbursements_count = Disbursement.where("strftime('%Y', disbursement_date) = ?", year.to_s).count
      total_disbursed_amount = Disbursement.where("strftime('%Y', disbursement_date) = ?", year.to_s).sum(:amount)
      total_order_fees = Order.where("strftime('%Y', disbursement_date) = ?", year.to_s).sum(:fee)
  
      # Add more calculations as needed
  
      # Print the results
      puts "Year: #{year}"
      puts "Number of Disbursements: #{disbursements_count}"
      puts "Total Disbursed Amount: #{total_disbursed_amount}"
      puts "Total Order Fees: #{total_order_fees}"
      # Print additional metrics
  
      # You can return the calculated values or use them as needed
      { disbursements_count: disbursements_count, total_disbursed_amount: total_disbursed_amount, total_order_fees: total_order_fees }
    end
  end
  