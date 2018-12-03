class RemoveColumnsFromTaskas < ActiveRecord::Migration[5.2]
  def change
    remove_column :taskas, :region, :text
    remove_column :taskas, :name, :text
    remove_column :taskas, :collection_id, :text
  end
end
