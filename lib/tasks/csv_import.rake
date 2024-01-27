require 'csv'
require 'byebug'

namespace :csv_import do
    desc "Import data from CSV files"
    task merchants: :environment do
      filename = Rails.root.join('app/data/merchants.csv')

      CSV.foreach(filename, headers: true, col_sep: ';') do |row|
        Merchant.find_or_create_by(internal_id: row['id']) do |merchant|
          merchant.reference = row['reference']
          merchant.email = row['email']
          merchant.live_on = row['live_on']
          merchant.disbursement_frequency = row['disbursement_frequency']
          merchant.minimum_monthly_fee = row['minimum_monthly_fee']
        end
      end
  
      puts "Merchants imported successfully!"
    end
  
    task orders: :environment do
      filename = Rails.root.join('app/data/orders.csv')
  
      CSV.foreach(filename, headers: true, col_sep: ';') do |row|
        merchant = Merchant.find_by(reference: row['merchant_reference'])
        if merchant.present?
            merchant.orders.create!(internal_id: row['id']) do |order|
              order.amount = row['amount']
              order.created_at = row['created_at']
            end
        else
            puts "Merchant with reference #{row['merchant_reference']} not found."
        end
      end
  
      puts "Orders imported successfully!"
    end
  end
  