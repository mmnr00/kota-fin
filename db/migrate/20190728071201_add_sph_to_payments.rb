class AddSphToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :s2ph, :boolean
  end
end
