class AddCourseToAnisprogs < ActiveRecord::Migration[5.2]
  def change
    add_column :anisprogs, :course_id, :integer
  end
end
