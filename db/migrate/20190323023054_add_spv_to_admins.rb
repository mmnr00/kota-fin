class AddSpvToAdmins < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :spv, :boolean
  end
end
