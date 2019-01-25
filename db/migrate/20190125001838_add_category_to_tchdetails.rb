class AddCategoryToTchdetails < ActiveRecord::Migration[5.2]
  def change
    add_column :tchdetails, :category, :string
  end
end
