class AddAns201ToTchdetails < ActiveRecord::Migration[5.2]
  def change
    add_column :tchdetails, :expjkm, :datetime
  end
end
