class AddDiscountToTaskas < ActiveRecord::Migration[5.2]
  def change
    add_column :taskas, :discount, :float
  end
end
