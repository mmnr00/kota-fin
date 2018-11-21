class AddFeeToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :base_fee, :float
  end
end
