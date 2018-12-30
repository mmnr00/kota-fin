class AddKindToExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :expenses, :kind, :string
  end
end
