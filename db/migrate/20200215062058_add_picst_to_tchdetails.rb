class AddPicstToTchdetails < ActiveRecord::Migration[5.2]
  def change
    add_column :tchdetails, :picst, :boolean
  end
end
