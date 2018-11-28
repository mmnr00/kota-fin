class AddDetailToTeachers < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers, :tchdetail_id, :integer
  end
end
