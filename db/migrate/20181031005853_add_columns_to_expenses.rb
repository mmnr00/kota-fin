class AddColumnsToExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :expenses, :month, :integer
    add_column :expenses, :year, :integer
  end
end
