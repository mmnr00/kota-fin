class AddParentToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :parent_id, :integer
  end
end
