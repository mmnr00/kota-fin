class AddUsernameToCollegeAdmins < ActiveRecord::Migration[5.2]
  def change
    add_column :college_admins, :username, :string
    add_index :college_admins, :username, unique: true
  end
end
