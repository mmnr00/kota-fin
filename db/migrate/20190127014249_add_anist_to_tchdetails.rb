class AddAnistToTchdetails < ActiveRecord::Migration[5.2]
  def change
    add_column :tchdetails, :anis, :string
  end
end
