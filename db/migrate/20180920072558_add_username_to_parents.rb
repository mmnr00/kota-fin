class AddUsernameToParents < ActiveRecord::Migration[5.2]
  def change
    add_column :parents, :username, :string
    add_index :parents, :username, unique: true
  end
end
