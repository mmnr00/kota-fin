class AddParpaymToFotos < ActiveRecord::Migration[5.2]
  def change
    add_column :fotos, :parpaym_id, :integer
  end
end
