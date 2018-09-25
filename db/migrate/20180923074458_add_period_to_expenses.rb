class AddPeriodToExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :expenses, :month, :string
    add_column :expenses, :year, :string
  end
end
