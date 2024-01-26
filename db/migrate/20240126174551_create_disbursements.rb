class CreateDisbursements < ActiveRecord::Migration[6.0]
  def change
    create_table :disbursements do |t|
      t.references :merchant, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :fee, precision: 10, scale: 2
      t.date :disbursement_date

      t.timestamps
    end
  end
end