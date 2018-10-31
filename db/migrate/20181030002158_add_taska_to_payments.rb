class AddTaskaToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :taska_id, :integer
  end
end
