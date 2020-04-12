class AddBilitmToTaskas < ActiveRecord::Migration[5.2]
  def change
    add_column :taskas, :bilitm, :text
  end
end
