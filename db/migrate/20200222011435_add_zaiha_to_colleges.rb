class AddZaihaToColleges < ActiveRecord::Migration[5.2]
  def change
    add_column :colleges, :clse, :datetime
    add_column :colleges, :appl, :boolean
  end
end
