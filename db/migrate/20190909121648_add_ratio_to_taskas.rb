class AddRatioToTaskas < ActiveRecord::Migration[5.2]
  def change
    add_column :taskas, :rato, :float
  end
end
