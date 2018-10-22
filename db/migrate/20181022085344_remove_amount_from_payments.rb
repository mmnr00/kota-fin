class RemoveAmountFromPayments < ActiveRecord::Migration[5.2]
  def change
    remove_column :payments, :amount, :integer
  end
end
