class AddEmailToTchdetails < ActiveRecord::Migration[5.2]
  def change
    add_column :tchdetails, :email, :string
  end
end
