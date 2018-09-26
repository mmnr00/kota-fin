class RemoveTaskaidFromTeachers < ActiveRecord::Migration[5.2]
  def change
    remove_column :teachers, :taska_id, :integer
  end
end
