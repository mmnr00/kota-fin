class AddClsToFotos < ActiveRecord::Migration[5.2]
  def change
    add_column :fotos, :classroom_id, :integer
  end
end
