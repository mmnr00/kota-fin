class AddCollegeToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :college_id, :integer
  end
end
