class AddCollectionToTaskas < ActiveRecord::Migration[5.2]
  def change
    add_column :taskas, :collection_id, :string
    add_index :taskas, :collection_id, unique: true
  end
end
