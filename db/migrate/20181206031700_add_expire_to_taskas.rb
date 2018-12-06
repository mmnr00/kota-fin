class AddExpireToTaskas < ActiveRecord::Migration[5.2]
  def change
    add_column :taskas, :expire, :datetime
  end
end
