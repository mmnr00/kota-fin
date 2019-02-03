class AddAddtnToTchdetails < ActiveRecord::Migration[5.2]
  def change
    add_column :tchdetails, :income, :string
    add_column :tchdetails, :dob, :date
    add_column :tchdetails, :gender, :string
  end
end
