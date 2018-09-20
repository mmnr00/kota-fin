class AddUsernameToTeachers < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers, :username, :string
    add_index :teachers, :username, unique: true
  end
end
