class AddColumnToTaskaTeachers < ActiveRecord::Migration[5.2]
  def change
    add_column :taska_teachers, :taska_id, :integer
    add_column :taska_teachers, :teacher_id, :integer
  end
end
