class AddMainfonToKids < ActiveRecord::Migration[5.2]
  def change
    add_column :kids, :ph_1, :string
    add_column :kids, :ph_2, :string
  end
end
