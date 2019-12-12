class AddTpToTeacherColleges < ActiveRecord::Migration[5.2]
  def change
    add_column :teacher_colleges, :tp, :string
  end
end
