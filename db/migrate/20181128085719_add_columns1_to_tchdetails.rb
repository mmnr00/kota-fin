class AddColumns1ToTchdetails < ActiveRecord::Migration[5.2]
  def change
    add_column :tchdetails, :teacher_id, :integer
  end
end
