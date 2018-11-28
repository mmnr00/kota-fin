class AddColumnsToTchdetails < ActiveRecord::Migration[5.2]
  def change
    add_column :tchdetails, :marital, :string
    add_column :tchdetails, :address_1, :string
    add_column :tchdetails, :address_2, :string
    add_column :tchdetails, :city, :string
    add_column :tchdetails, :states, :string
    add_column :tchdetails, :postcode, :string
    add_column :tchdetails, :education, :string
  end
end
