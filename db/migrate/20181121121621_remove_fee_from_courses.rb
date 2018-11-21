class RemoveFeeFromCourses < ActiveRecord::Migration[5.2]
  def change
    remove_column :courses, :base_fee, :integer
  end
end
