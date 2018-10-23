class AddBaseToKids < ActiveRecord::Migration[5.2]
  def change
    add_column :kids, :base_fee, :float
  end
end
