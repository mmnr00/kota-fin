class AddParentToPrntdetails < ActiveRecord::Migration[5.2]
  def change
    add_column :prntdetails, :parent_id, :integer
  end
end
