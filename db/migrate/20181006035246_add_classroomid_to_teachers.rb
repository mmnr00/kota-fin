class AddClassroomidToTeachers < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers, :classroom_id, :integer
  end
end
