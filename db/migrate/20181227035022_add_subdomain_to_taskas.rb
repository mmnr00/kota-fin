class AddSubdomainToTaskas < ActiveRecord::Migration[5.2]
  def change
    add_column :taskas, :subdomain, :string
    add_index :taskas, :subdomain, unique: true
  end
end
