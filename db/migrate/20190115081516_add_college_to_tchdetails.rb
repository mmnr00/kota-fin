class AddCollegeToTchdetails < ActiveRecord::Migration[5.2]
  def change
    add_column :tchdetails, :college_id, :integer
  end
end
