class RemoveColumnFromTeachers < ActiveRecord::Migration[5.2]
  def change
    remove_column :teachers, :tchdetail_id, :integer
  end
end
