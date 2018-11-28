class AddColumns1ToFotos < ActiveRecord::Migration[5.2]
  def change
    add_column :fotos, :tchdetail_id, :integer
    add_column :fotos, :foto_name, :string
  end
end
