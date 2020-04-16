class AddPdtToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :pdt, :date
  end
end
