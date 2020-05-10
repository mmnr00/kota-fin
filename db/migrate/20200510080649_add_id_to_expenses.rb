class AddIdToExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :expenses, :exp_id, :string
  end
end
