class AddTotToApplvs < ActiveRecord::Migration[5.2]
  def change
    add_column :applvs, :tot, :float
  end
end
