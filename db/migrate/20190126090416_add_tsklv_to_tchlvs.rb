class AddTsklvToTchlvs < ActiveRecord::Migration[5.2]
  def change
    add_column :tchlvs, :tsklv_id, :integer
  end
end
