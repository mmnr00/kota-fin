class AddRaediToExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :expenses, :dt, :date
    add_column :expenses, :coname, :string
    add_column :expenses, :catg, :string
  end
end
