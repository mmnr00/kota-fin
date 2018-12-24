class AddReminderToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :reminder, :boolean
  end
end
