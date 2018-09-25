class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.string :name
      t.decimal :cost
      t.date :period

      t.timestamps
    end
  end
end
