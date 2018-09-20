class AddRowsToTaskas < ActiveRecord::Migration[5.2]
  def change
    add_column :taskas, :region, :string
    add_column :taskas, :email, :string
    add_index :taskas, :email, unique: true
    add_column :taskas, :name, :string
    add_index :taskas, :name, unique: true
  end
end
