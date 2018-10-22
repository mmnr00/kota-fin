class AddColumnsToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :bill_month, :integer
    add_column :payments, :bill_year, :integer
    add_column :payments, :bill_id, :string
    add_column :payments, :amount, :integer
    add_column :payments, :description, :string
    add_column :payments, :state, :string
    add_column :payments, :paid, :boolean
    add_column :payments, :kid_id, :integer
  end
end
