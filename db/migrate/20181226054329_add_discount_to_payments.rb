class AddDiscountToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :discount, :float
  end
end
