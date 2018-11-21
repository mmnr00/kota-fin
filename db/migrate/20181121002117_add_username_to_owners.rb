class AddUsernameToOwners < ActiveRecord::Migration[5.2]
  def change
    add_column :owners, :username, :string
    add_index :owners, :username, unique: true
  end
end
