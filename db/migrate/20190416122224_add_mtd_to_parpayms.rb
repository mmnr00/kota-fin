class AddMtdToParpayms < ActiveRecord::Migration[5.2]
  def change
    add_column :parpayms, :mtd, :string
  end
end
