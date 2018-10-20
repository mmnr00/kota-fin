class AddColumnToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :collection_id, :string
    add_column :payments, :collection_name, :string
  end
end
