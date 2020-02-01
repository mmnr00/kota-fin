class AddAndsToTchdetails < ActiveRecord::Migration[5.2]
  def change
    add_column :tchdetails, :ands, :string
  end
end
