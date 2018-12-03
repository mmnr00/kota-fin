class AddTaskaToFotos < ActiveRecord::Migration[5.2]
  def change
    add_column :fotos, :taska_id, :integer
  end
end
