class AddAdmToExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :expenses, :adm, :integer
  end
end
