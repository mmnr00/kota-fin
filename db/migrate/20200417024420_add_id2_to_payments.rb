class AddId2ToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :bill_id2, :string
  end
end
