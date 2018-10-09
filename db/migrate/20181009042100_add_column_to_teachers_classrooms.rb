class AddColumnToTeachersClassrooms < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers_classrooms, :teacher_id, :integer
    add_column :teachers_classrooms, :classroom_id, :integer
  end
end
