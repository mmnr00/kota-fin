class AddNwToExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :expenses, :desc, :string
    add_column :expenses, :ph, :string
  end
end
