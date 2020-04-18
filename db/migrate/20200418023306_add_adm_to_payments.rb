class AddAdmToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :adm, :integer
  end
end
