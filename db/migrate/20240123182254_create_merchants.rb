class CreateMerchants < ActiveRecord::Migration[7.1]
  def change
    create_table :merchants do |t|
      t.string "email"
      t.string "reference"
      t.string "internal_id", null: false
      t.date "live_on"
      t.decimal "minimum_monthly_fee", precision: 10, scale: 2
      t.string "disbursement_frequency"
      t.index ["internal_id"], name: "index_merchants_on_internal_id", unique: true
      t.index ["reference"], name: "index_merchants_on_reference", unique: true

      t.timestamps
    end
  end
end
