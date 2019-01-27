class AddAniscToTchdetails < ActiveRecord::Migration[5.2]
  def change
    add_column :tchdetails, :dun, :string
    add_column :tchdetails, :jkm, :string
    add_column :tchdetails, :post, :string
  end
end
