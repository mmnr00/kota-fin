class AddAcvToColleges < ActiveRecord::Migration[5.2]
  def change
    add_column :colleges, :acv, :boolean
  end
end
