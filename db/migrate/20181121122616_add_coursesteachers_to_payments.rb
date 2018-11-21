class AddCoursesteachersToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :course_id, :integer
    add_column :payments, :teacher_id, :integer
  end
end
