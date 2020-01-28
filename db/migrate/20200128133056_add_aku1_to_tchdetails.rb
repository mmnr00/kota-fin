class AddAku1ToTchdetails < ActiveRecord::Migration[5.2]
  def change
    add_column :tchdetails, :akun, :boolean
  end
end
