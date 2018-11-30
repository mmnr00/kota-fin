class RemoveColumnsFromKids < ActiveRecord::Migration[5.2]
  def change
    remove_column :kids, :base_fee, :float
    remove_column :kids, :classroom_id, :integer
  end
end
