class RemoveColumnsFromExpenses < ActiveRecord::Migration[5.2]
  def change
    remove_column :expenses, :month, :string
    remove_column :expenses, :year, :string
  end
end
