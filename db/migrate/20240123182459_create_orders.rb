class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.decimal "amount", precision: 10, scale: 2
      t.string "internal_id", null: false
      t.integer "merchant_id"
      t.index ["internal_id"], name: "index_orders_on_internal_id", unique: true
      t.index ["merchant_id"], name: "index_orders_on_merchant_id"

      t.timestamps
    end
  end
end
