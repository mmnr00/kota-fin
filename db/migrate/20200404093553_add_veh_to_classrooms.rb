class AddVehToClassrooms < ActiveRecord::Migration[5.2]
  def change
    add_column :classrooms, :vehls, :text
  end
end
