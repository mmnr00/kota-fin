class RemoveColumnFromPayments < ActiveRecord::Migration[5.2]
  def change
    remove_column :payments, :collection_id, :integer
    remove_column :payments, :name, :string
  end
end
