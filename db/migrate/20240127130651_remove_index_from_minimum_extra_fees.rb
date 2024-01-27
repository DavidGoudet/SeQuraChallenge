class RemoveIndexFromMinimumExtraFees < ActiveRecord::Migration[7.1]
  def change
    remove_index :minimum_extra_fees, name: "index_minimum_extra_fees_on_disbursement_id"
    remove_column :minimum_extra_fees, :disbursement_id, :integer
  end
end
