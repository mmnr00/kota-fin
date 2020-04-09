class AddClsToExtras < ActiveRecord::Migration[5.2]
  def change
    add_column :extras, :classroom_id, :integer
  end
end
