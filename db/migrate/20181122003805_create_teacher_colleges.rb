class CreateTeacherColleges < ActiveRecord::Migration[5.2]
  def change
    create_table :teacher_colleges do |t|
      t.integer :teacher_id
      t.integer :college_id

      t.timestamps
    end
  end
end
