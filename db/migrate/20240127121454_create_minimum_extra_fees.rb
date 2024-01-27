class CreateMinimumExtraFees < ActiveRecord::Migration[7.1]
  def change
    create_table :minimum_extra_fees do |t|
      t.decimal :fee_amount, precision: 10, scale: 2
      t.references :merchant, null: false, foreign_key: true
      t.references :disbursement, null: false, foreign_key: true

      t.timestamps
    end
  end
end
