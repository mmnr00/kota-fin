class RemovePeriodFromExpenses < ActiveRecord::Migration[5.2]
  def change
    remove_column :expenses, :period, :date
  end
end
