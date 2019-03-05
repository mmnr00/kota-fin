class AddPaymentToFotos < ActiveRecord::Migration[5.2]
  def change
    add_column :fotos, :payment_id, :integer
  end
end
