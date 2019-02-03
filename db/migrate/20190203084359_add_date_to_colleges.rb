class AddDateToColleges < ActiveRecord::Migration[5.2]
  def change
    add_column :colleges, :start, :date
    add_column :colleges, :end, :date
  end
end
