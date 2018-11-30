class AddColumns5ToFotos < ActiveRecord::Migration[5.2]
  def change
    add_column :fotos, :kid_id, :integer
  end
end
