class AddClsToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :classroom_id, :integer
  end
end
