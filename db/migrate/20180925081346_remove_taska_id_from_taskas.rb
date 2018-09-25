class RemoveTaskaIdFromTaskas < ActiveRecord::Migration[5.2]
  def change
    remove_column :taskas, :taska_id, :integer
  end
end
