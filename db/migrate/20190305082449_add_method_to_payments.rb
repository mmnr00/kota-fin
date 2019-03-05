class AddMethodToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :mtd, :string
  end
end
