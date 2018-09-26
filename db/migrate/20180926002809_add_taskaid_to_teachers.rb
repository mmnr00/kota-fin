class AddTaskaidToTeachers < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers, :taska_id, :integer
  end
end
