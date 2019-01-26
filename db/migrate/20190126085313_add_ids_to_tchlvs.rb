class AddIdsToTchlvs < ActiveRecord::Migration[5.2]
  def change
    add_column :tchlvs, :taska_id, :integer
    add_column :tchlvs, :teacher_id, :integer
  end
end
