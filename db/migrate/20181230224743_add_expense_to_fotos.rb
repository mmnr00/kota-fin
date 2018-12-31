class AddExpenseToFotos < ActiveRecord::Migration[5.2]
  def change
    add_column :fotos, :expense_id, :integer
  end
end
