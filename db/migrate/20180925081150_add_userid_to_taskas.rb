class AddUseridToTaskas < ActiveRecord::Migration[5.2]
  def change
    add_column :taskas, :taska_id, :integer
  end
end
