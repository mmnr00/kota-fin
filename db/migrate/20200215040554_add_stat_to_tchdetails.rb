class AddStatToTchdetails < ActiveRecord::Migration[5.2]
  def change
    add_column :tchdetails, :stat, :string
  end
end
