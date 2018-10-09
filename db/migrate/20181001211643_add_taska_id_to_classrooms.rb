class AddTaskaIdToClassrooms < ActiveRecord::Migration[5.2]
  def change
    add_column :classrooms, :taska_id, :integer
  end
end
