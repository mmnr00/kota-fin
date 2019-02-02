class AddProgToAnisatts < ActiveRecord::Migration[5.2]
  def change
    add_column :anisatts, :anisprog_id, :integer
  end
end
