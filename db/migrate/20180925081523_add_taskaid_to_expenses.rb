class AddTaskaidToExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :expenses, :taska_id, :integer
  end
end
