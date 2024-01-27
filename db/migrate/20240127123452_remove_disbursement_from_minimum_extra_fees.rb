class RemoveDisbursementFromMinimumExtraFees < ActiveRecord::Migration[7.1]
  def change
    remove_column :minimum_extra_fees, :disbursement, :string
  end
end
