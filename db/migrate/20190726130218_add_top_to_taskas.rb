class AddTopToTaskas < ActiveRecord::Migration[5.2]
  def change
    add_column :taskas, :cred, :float
    add_column :taskas, :hiscred, :text
  end
end
