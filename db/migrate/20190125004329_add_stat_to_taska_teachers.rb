class AddStatToTaskaTeachers < ActiveRecord::Migration[5.2]
  def change
    add_column :taska_teachers, :stat, :boolean
  end
end
