class RemoveColumsFromPayments < ActiveRecord::Migration[5.2]
  def change
    remove_column :payments, :collection_id, :string
    remove_column :payments, :collection_name, :string
  end
end
