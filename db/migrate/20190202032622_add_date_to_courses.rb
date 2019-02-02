class AddDateToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :start, :date
    add_column :courses, :end, :date
  end
end
