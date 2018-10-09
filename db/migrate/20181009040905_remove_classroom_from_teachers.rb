class RemoveClassroomFromTeachers < ActiveRecord::Migration[5.2]
  def change
    remove_column :teachers, :classroom_id, :integer
  end
end
