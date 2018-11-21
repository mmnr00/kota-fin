class CreateTeacherCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :teacher_courses do |t|
      t.integer :teacher_id
      t.integer :course_id

      t.timestamps
    end
  end
end
