class AddApplvToFotos < ActiveRecord::Migration[5.2]
  def change
    add_column :fotos, :applv_id, :integer
  end
end
