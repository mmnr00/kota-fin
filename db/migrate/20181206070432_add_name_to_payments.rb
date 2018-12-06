class AddNameToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :name, :string
  end
end
